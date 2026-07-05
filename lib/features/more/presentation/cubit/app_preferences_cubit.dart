import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/more/presentation/cubit/app_preferences_state.dart';

class AppPreferencesCubit extends Cubit<AppPreferencesState> {
  AppPreferencesCubit() : super(const AppPreferencesState());

  void setThemeMode(String mode) => emit(state.copyWith(themeMode: mode));
  void setLanguage(String lang) => emit(state.copyWith(language: lang));
  void setUnits(String units) => emit(state.copyWith(units: units));
}
