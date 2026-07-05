import 'package:afia/features/more/domain/entities/notification_preferences.dart';

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    super.enabled = true,
    super.waterReminder = true,
    super.waterIntervalHours = 2,
    super.mealReminder = true,
    super.mealTimes = const ['08:00', '13:00', '20:00'],
    super.weighInReminder = false,
    super.weighInDay = 'Monday',
    super.progressSummary = false,
    super.summaryFrequency = 'weekly',
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      enabled: json['enabled'] as bool? ?? true,
      waterReminder: json['waterReminder'] as bool? ?? true,
      waterIntervalHours: json['waterIntervalHours'] as int? ?? 2,
      mealReminder: json['mealReminder'] as bool? ?? true,
      mealTimes:
          (json['mealTimes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['08:00', '13:00', '20:00'],
      weighInReminder: json['weighInReminder'] as bool? ?? false,
      weighInDay: json['weighInDay'] as String? ?? 'Monday',
      progressSummary: json['progressSummary'] as bool? ?? false,
      summaryFrequency: json['summaryFrequency'] as String? ?? 'weekly',
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'waterReminder': waterReminder,
    'waterIntervalHours': waterIntervalHours,
    'mealReminder': mealReminder,
    'mealTimes': mealTimes,
    'weighInReminder': weighInReminder,
    'weighInDay': weighInDay,
    'progressSummary': progressSummary,
    'summaryFrequency': summaryFrequency,
  };

  factory NotificationPreferencesModel.fromEntity(
    NotificationPreferences entity,
  ) {
    return NotificationPreferencesModel(
      enabled: entity.enabled,
      waterReminder: entity.waterReminder,
      waterIntervalHours: entity.waterIntervalHours,
      mealReminder: entity.mealReminder,
      mealTimes: entity.mealTimes,
      weighInReminder: entity.weighInReminder,
      weighInDay: entity.weighInDay,
      progressSummary: entity.progressSummary,
      summaryFrequency: entity.summaryFrequency,
    );
  }
}
