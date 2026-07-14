import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsCubit extends Cubit<MealsState> {
  final MealRemoteDataSource _remoteDataSource;
  final MoreRemoteDataSource _moreDataSource;

  MealsCubit({
    required MealRemoteDataSource remoteDataSource,
    required MoreRemoteDataSource moreDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _moreDataSource = moreDataSource,
       super(MealsState(selectedDate: DateTime.now())) {
    loadMeals();
  }

  Future<void> loadMeals() async {
    emit(state.copyWith(status: MealsStatus.loading));

    try {
      // 1. Fetch calorie goal & macros from preferences
      final dietPrefs = await _moreDataSource.getDietPreferences();
      final calorieGoal = dietPrefs.calorieTarget ?? 2000;
      final carbsPct = dietPrefs.carbsPct ?? 50;
      final proteinPct = dietPrefs.proteinPct ?? 20;
      final fatPct = dietPrefs.fatPct ?? 30;

      final carbsGoal = (calorieGoal * carbsPct / 100 / 4).round();
      final proteinGoal = (calorieGoal * proteinPct / 100 / 4).round();
      final fatGoal = (calorieGoal * fatPct / 100 / 9).round();

      // 2. Fetch logged meals
      final loggedMeals = await _remoteDataSource.getLoggedMeals(
        state.selectedDate,
      );

      final defaultSlots = [
        MealSlotDetail(
          name: 'Breakfast',
          emoji: '🥣',
          type: 'breakfast',
          loggedMeals: loggedMeals
              .where((m) => m.slotType == 'breakfast')
              .toList(),
        ),
        MealSlotDetail(
          name: 'Lunch',
          emoji: '🥗',
          type: 'lunch',
          loggedMeals: loggedMeals.where((m) => m.slotType == 'lunch').toList(),
        ),
        MealSlotDetail(
          name: 'Dinner',
          emoji: '🍛',
          type: 'dinner',
          loggedMeals: loggedMeals
              .where((m) => m.slotType == 'dinner')
              .toList(),
        ),
        MealSlotDetail(
          name: 'Snack',
          emoji: '🍎',
          type: 'snack',
          loggedMeals: loggedMeals.where((m) => m.slotType == 'snack').toList(),
        ),
      ];

      print(
        "MealsCubit: loadMeals finished. Emitting state. status=${defaultSlots.any((s) => s.isLogged) ? MealsStatus.success : MealsStatus.empty}, loggedMeals count=${loggedMeals.length}",
      );
      emit(
        state.copyWith(
          status: defaultSlots.any((s) => s.isLogged)
              ? MealsStatus.success
              : MealsStatus.empty,
          slots: defaultSlots,
          calorieGoal: calorieGoal,
          carbsGoal: carbsGoal,
          proteinGoal: proteinGoal,
          fatGoal: fatGoal,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  Future<void> selectDate(DateTime date) async {
    if (_isSameDay(state.selectedDate, date)) return;
    emit(state.copyWith(selectedDate: date, status: MealsStatus.loading));
    await loadMeals();
  }

  void addMealToSlot(String slotType, MealSummary meal) async {
    final previousState = state;
    final tempId = 'temp_${DateTime.now().microsecondsSinceEpoch}';
    final tempMeal = MealSummary(
      id: tempId,
      name: meal.name,
      nameAr: meal.nameAr,
      emoji: meal.emoji,
      servingLabel: meal.servingLabel,
      servingLabelAr: meal.servingLabelAr,
      calories: meal.calories,
      tags: meal.tags,
    );

    // Optimistically add the meal to the target slot
    final updatedSlots = state.slots.map((slot) {
      if (slot.type == slotType) {
        return slot.copyWith(
          loggedMeals: [...slot.loggedMeals, tempMeal],
        );
      }
      return slot;
    }).toList();

    emit(state.copyWith(
      slots: updatedSlots,
      status: MealsStatus.success,
    ));

    try {
      final insertedMeal = await _remoteDataSource.insertMeal(meal, slotType, state.selectedDate);
      
      if (!isClosed) {
        // Silently replace temporary meal with the inserted database row (contains real UUID)
        final finalSlots = state.slots.map((slot) {
          if (slot.type == slotType) {
            return slot.copyWith(
              loggedMeals: slot.loggedMeals.map((m) {
                return m.id == tempId ? insertedMeal : m;
              }).toList(),
            );
          }
          return slot;
        }).toList();

        emit(state.copyWith(
          slots: finalSlots,
          status: MealsStatus.success,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(previousState);
      }
    }
  }

  void deleteMealFromSlot(String slotType, String mealId) async {
    final previousState = state;

    // Optimistically filter out the deleted meal
    final updatedSlots = state.slots.map((slot) {
      if (slot.type == slotType) {
        return slot.copyWith(
          loggedMeals: slot.loggedMeals.where((m) => m.id != mealId).toList(),
        );
      }
      return slot;
    }).toList();

    emit(state.copyWith(
      slots: updatedSlots,
      status: updatedSlots.any((s) => s.isLogged) ? MealsStatus.success : MealsStatus.empty,
    ));

    try {
      if (!mealId.startsWith('temp_')) {
        await _remoteDataSource.deleteMeal(mealId);
      }
    } catch (e) {
      if (!isClosed) {
        emit(previousState);
      }
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
