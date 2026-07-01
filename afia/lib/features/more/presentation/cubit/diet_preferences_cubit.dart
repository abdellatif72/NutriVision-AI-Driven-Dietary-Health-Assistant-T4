import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/more/presentation/cubit/diet_preferences_state.dart';

class DietPreferencesCubit extends Cubit<DietPreferencesState> {
  DietPreferencesCubit() : super(const DietPreferencesState());

  void updateDietStyle(String value) => emit(state.copyWith(dietStyle: value));
  void updateGoalType(String value) => emit(state.copyWith(goalType: value));
  void updateCalorieTarget(int value) =>
      emit(state.copyWith(calorieTarget: value));
  void updateCarbsPct(int value) => emit(state.copyWith(carbsPct: value));
  void updateProteinPct(int value) => emit(state.copyWith(proteinPct: value));
  void updateFatPct(int value) => emit(state.copyWith(fatPct: value));
  void updateMealsPerDay(int value) => emit(state.copyWith(mealsPerDay: value));
  void toggleFasting() =>
      emit(state.copyWith(fastingEnabled: !state.fastingEnabled));
  void updateWaterGoal(int value) => emit(state.copyWith(waterGoalMl: value));

  void toggleAllergy(String allergy) {
    final list = List<String>.from(state.allergies);
    list.contains(allergy) ? list.remove(allergy) : list.add(allergy);
    emit(state.copyWith(allergies: list));
  }

  Future<void> save() async {
    emit(state.copyWith(isSaving: true));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isSaving: false, isSuccess: true));
  }

  void resetSuccess() => emit(state.copyWith(isSuccess: false));
}
