import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit({required MealRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(MealsState(selectedDate: DateTime.now())) {
    loadMeals();
  }

  final MealRemoteDataSource _remoteDataSource;

  void loadMeals() async {
    emit(state.copyWith(status: MealsStatus.loading));

    try {
      final loggedMeals = await _remoteDataSource.getLoggedMeals(state.selectedDate);

      final defaultSlots = [
        MealSlotDetail(
          name: 'Breakfast',
          emoji: '🥣',
          type: 'breakfast',
          loggedMeals: loggedMeals.where((m) => m.slotType == 'breakfast').toList(),
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
          loggedMeals: loggedMeals.where((m) => m.slotType == 'dinner').toList(),
        ),
        MealSlotDetail(
          name: 'Snack',
          emoji: '🍎',
          type: 'snack',
          loggedMeals: loggedMeals.where((m) => m.slotType == 'snack').toList(),
        ),
      ];

      emit(state.copyWith(
        status: defaultSlots.any((s) => s.isLogged) ? MealsStatus.success : MealsStatus.empty,
        slots: defaultSlots,
      ));
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  void selectDate(DateTime date) {
    if (_isSameDay(state.selectedDate, date)) return;
    emit(state.copyWith(selectedDate: date, status: MealsStatus.loading));
    loadMeals();
  }

  void addMealToSlot(String slotType, MealSummary meal) async {
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      await _remoteDataSource.insertMeal(meal, slotType, state.selectedDate);
      loadMeals();
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  void deleteMealFromSlot(String slotType, String mealId) async {
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      await _remoteDataSource.deleteMeal(mealId);
      loadMeals();
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
