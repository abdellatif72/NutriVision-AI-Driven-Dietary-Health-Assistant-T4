import 'package:afia/features/more/domain/entities/app_preferences.dart';

class AppPreferencesModel extends AppPreferences {
  const AppPreferencesModel({
    super.themeMode = 'system',
    super.language = 'ar',
    super.units = 'metric',
  });

  factory AppPreferencesModel.fromJson(Map<String, dynamic> json) {
    return AppPreferencesModel(
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'ar',
      units: json['units'] as String? ?? 'metric',
    );
  }

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode,
    'language': language,
    'units': units,
  };

  factory AppPreferencesModel.fromEntity(AppPreferences entity) {
    return AppPreferencesModel(
      themeMode: entity.themeMode,
      language: entity.language,
      units: entity.units,
    );
  }
}
