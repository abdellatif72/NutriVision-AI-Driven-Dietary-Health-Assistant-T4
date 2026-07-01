import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit() : super(MealsState(selectedDate: DateTime.now())) {
    loadMeals();
  }

  void loadMeals() async {
    emit(state.copyWith(status: MealsStatus.loading));
    // Simulate minor delay
    await Future<void>.delayed(const Duration(milliseconds: 150));

    final isTodayDate = _isSameDay(state.selectedDate, DateTime.now());

    final defaultSlots = [
      MealSlotDetail(
        name: 'Breakfast',
        emoji: '🥣',
        type: 'breakfast',
        loggedMeals: isTodayDate
            ? const [
                MealSummary(
                  id: 'mock-breakfast-1',
                  name: 'Oatmeal with berries',
                  emoji: '🥣',
                  servingLabel: '1 bowl · 150g',
                  calories: 420,
                ),
              ]
            : const [],
      ),
      MealSlotDetail(
        name: 'Lunch',
        emoji: '🥗',
        type: 'lunch',
        loggedMeals: isTodayDate
            ? const [
                MealSummary(
                  id: 'mock-lunch-1',
                  name: 'Koshari + salad',
                  emoji: '🥗',
                  servingLabel: '1 plate · 350g',
                  calories: 680,
                ),
              ]
            : const [],
      ),
      const MealSlotDetail(
        name: 'Dinner',
        emoji: '🍛',
        type: 'dinner',
        loggedMeals: [],
      ),
      const MealSlotDetail(
        name: 'Snack',
        emoji: '🍎',
        type: 'snack',
        loggedMeals: [],
      ),
    ];

    emit(state.copyWith(
      status: defaultSlots.any((s) => s.isLogged) ? MealsStatus.success : MealsStatus.empty,
      slots: defaultSlots,
    ));
  }

  void selectDate(DateTime date) {
    if (_isSameDay(state.selectedDate, date)) return;
    emit(state.copyWith(selectedDate: date, status: MealsStatus.loading));
    loadMeals();
  }

  void addMealToSlot(String slotType, MealSummary meal) {
    final updatedSlots = state.slots.map((slot) {
      if (slot.type == slotType) {
        final uniqueId = '${meal.id}-${DateTime.now().millisecondsSinceEpoch}';
        final mealWithUniqueId = MealSummary(
          id: uniqueId,
          name: meal.name,
          emoji: meal.emoji,
          servingLabel: meal.servingLabel,
          calories: meal.calories,
        );
        return slot.copyWith(
          loggedMeals: [...slot.loggedMeals, mealWithUniqueId],
        );
      }
      return slot;
    }).toList();

    emit(state.copyWith(
      slots: updatedSlots,
      status: updatedSlots.any((s) => s.isLogged) ? MealsStatus.success : MealsStatus.empty,
    ));
  }

  void deleteMealFromSlot(String slotType, String mealId) {
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
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
