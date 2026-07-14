import 'package:flutter/material.dart';
import 'package:afia/app/localization/app_localizations.dart';

export 'package:afia/app/localization/app_localizations.dart';

abstract final class AppLocales {
  static List<Locale> get supported => AppLocalizations.supportedLocales;
  static List<LocalizationsDelegate<dynamic>> get delegates => AppLocalizations.localizationsDelegates;
}
