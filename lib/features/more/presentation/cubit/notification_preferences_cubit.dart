import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/more/presentation/cubit/notification_preferences_state.dart';

class NotificationPreferencesCubit extends Cubit<NotificationPreferencesState> {
  NotificationPreferencesCubit() : super(const NotificationPreferencesState());

  void toggleEnabled() => emit(state.copyWith(enabled: !state.enabled));
  void toggleWaterReminder() =>
      emit(state.copyWith(waterReminder: !state.waterReminder));
  void updateWaterInterval(int hours) =>
      emit(state.copyWith(waterIntervalHours: hours));
  void toggleMealReminder() =>
      emit(state.copyWith(mealReminder: !state.mealReminder));
  void toggleWeighInReminder() =>
      emit(state.copyWith(weighInReminder: !state.weighInReminder));
  void updateWeighInDay(String day) => emit(state.copyWith(weighInDay: day));
  void toggleProgressSummary() =>
      emit(state.copyWith(progressSummary: !state.progressSummary));
  void updateSummaryFrequency(String freq) =>
      emit(state.copyWith(summaryFrequency: freq));

  Future<void> save() async {
    emit(state.copyWith(isSaving: true));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isSaving: false));
  }
}
