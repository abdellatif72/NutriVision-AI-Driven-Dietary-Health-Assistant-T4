import 'package:equatable/equatable.dart';

class AppPreferencesState extends Equatable {
  const AppPreferencesState({
    this.themeMode = 'system',
    this.language = 'ar',
    this.units = 'metric',
  });

  final String themeMode;
  final String language;
  final String units;

  AppPreferencesState copyWith({
    String? themeMode,
    String? language,
    String? units,
  }) {
    return AppPreferencesState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      units: units ?? this.units,
    );
  }

  @override
  List<Object?> get props => [themeMode, language, units];
}
