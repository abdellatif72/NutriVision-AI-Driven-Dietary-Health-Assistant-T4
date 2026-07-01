import 'package:equatable/equatable.dart';

class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    this.enabled = true,
    this.waterReminder = true,
    this.waterIntervalHours = 2,
    this.mealReminder = true,
    this.mealTimes = const ['08:00', '13:00', '20:00'],
    this.weighInReminder = false,
    this.weighInDay = 'Monday',
    this.progressSummary = false,
    this.summaryFrequency = 'weekly',
  });

  final bool enabled;
  final bool waterReminder;
  final int waterIntervalHours;
  final bool mealReminder;
  final List<String> mealTimes;
  final bool weighInReminder;
  final String weighInDay;
  final bool progressSummary;
  final String summaryFrequency;

  NotificationPreferences copyWith({
    bool? enabled,
    bool? waterReminder,
    int? waterIntervalHours,
    bool? mealReminder,
    List<String>? mealTimes,
    bool? weighInReminder,
    String? weighInDay,
    bool? progressSummary,
    String? summaryFrequency,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      waterReminder: waterReminder ?? this.waterReminder,
      waterIntervalHours: waterIntervalHours ?? this.waterIntervalHours,
      mealReminder: mealReminder ?? this.mealReminder,
      mealTimes: mealTimes ?? this.mealTimes,
      weighInReminder: weighInReminder ?? this.weighInReminder,
      weighInDay: weighInDay ?? this.weighInDay,
      progressSummary: progressSummary ?? this.progressSummary,
      summaryFrequency: summaryFrequency ?? this.summaryFrequency,
    );
  }

  @override
  List<Object?> get props => [
    enabled,
    waterReminder,
    waterIntervalHours,
    mealReminder,
    mealTimes,
    weighInReminder,
    weighInDay,
    progressSummary,
    summaryFrequency,
  ];
}
