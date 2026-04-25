import 'package:afia/app/theme/app_colors.dart';
import 'package:afia/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.ctaFood,
        surface: AppColors.surface,
        tertiary: AppColors.hydration,
        outline: AppColors.divider,
      ),
      dividerColor: AppColors.divider,
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
    );
  }
}
