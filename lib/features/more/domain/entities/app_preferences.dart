import 'package:equatable/equatable.dart';

class AppPreferences extends Equatable {
  const AppPreferences({
    this.themeMode = 'system',
    this.language = 'ar',
    this.units = 'metric',
  });

  final String themeMode;
  final String language;
  final String units;

  AppPreferences copyWith({
    String? themeMode,
    String? language,
    String? units,
  }) {
    return AppPreferences(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      units: units ?? this.units,
    );
  }

  @override
  List<Object?> get props => [themeMode, language, units];
}
