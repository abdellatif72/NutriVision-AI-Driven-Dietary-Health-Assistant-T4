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
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      await _remoteDataSource.insertMeal(meal, slotType, state.selectedDate);
      await loadMeals();
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  void deleteMealFromSlot(String slotType, String mealId) async {
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      await _remoteDataSource.deleteMeal(mealId);
      await loadMeals();
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
