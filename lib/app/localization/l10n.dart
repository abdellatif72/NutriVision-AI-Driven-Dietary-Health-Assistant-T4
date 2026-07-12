import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract final class AppLocales {
  static const supported = [Locale('en'), Locale('ar')];
  
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    localizationsDelegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const _localizedValues = {
    'en': {
      'home': 'Home',
      'meals': 'Meals',
      'chat': 'Chat',
      'more': 'More',
      'water': 'Water',
      'settings': 'Settings',
      'language': 'Language',
      'change_language': 'Change Language',
      'app_language': 'App Language',
      'daily_intake': 'Daily Intake',
      'steps': 'Steps',
      'hydration': 'Hydration',
      'heart_rate': 'Heart Rate',
      'kcal': 'kcal',
      'water_tracker': 'Hydration Tracker',
      'ai_nutrition_assistant': 'Smart Nutrition Assistant',
      'ask_nutrition': 'Ask me about nutrition, meals, or your health progress',
      'type_question': 'Type your question here...',
      'theme': 'Theme',
      'security': 'Security',
      'support': 'Support',
      'log_out': 'Log Out',
      'change_password': 'Change Password',
    },
    'ar': {
      'home': 'الرئيسية',
      'meals': 'الوجبات',
      'chat': 'المساعد الذكي',
      'more': 'المزيد',
      'water': 'الماء',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'change_language': 'تغيير اللغة',
      'app_language': 'لغة التطبيق',
      'daily_intake': 'الاحتياج اليومي',
      'steps': 'الخطوات',
      'hydration': 'الترطيب',
      'heart_rate': 'نبضات القلب',
      'kcal': 'سعر حراري',
      'water_tracker': 'متابع شرب الماء',
      'ai_nutrition_assistant': 'مساعدك الغذائي الذكي',
      'ask_nutrition': 'اسألني عن التغذية، الوجبات، أو تقدمك الصحي',
      'type_question': 'اكتب سؤالك هنا...',
      'theme': 'المظهر',
      'security': 'الأمان',
      'support': 'الدعم',
      'log_out': 'تسجيل الخروج',
      'change_password': 'تغيير كلمة المرور',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

const localizationsDelegate = _AppLocalizationsDelegate();
