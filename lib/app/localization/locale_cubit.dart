import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afia/app/di/injection_container.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadLocale();
  }

  static const String _localeKey = 'selected_locale';

  Future<void> _loadLocale() async {
    final prefs = sl<SharedPreferences>();
    final savedCode = prefs.getString(_localeKey) ?? 'en';
    emit(Locale(savedCode));
  }

  Future<void> setLocale(String languageCode) async {
    if (state.languageCode == languageCode) return;
    final prefs = sl<SharedPreferences>();
    await prefs.setString(_localeKey, languageCode);
    emit(Locale(languageCode));
  }
}
