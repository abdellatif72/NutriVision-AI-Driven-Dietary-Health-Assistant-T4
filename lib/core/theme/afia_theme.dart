import 'package:flutter/material.dart';
import 'afia_colors.dart';
import 'afia_spacing.dart';
import 'afia_typography.dart';

/// Assembles the tokens in [AfiaColors] / [AfiaTypography] / [AfiaSpacing]
/// into a single ThemeData so screens can just say `Theme.of(context)`
/// instead of importing tokens individually everywhere.
class AfiaTheme {
  AfiaTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AfiaColors.primary,
      brightness: Brightness.light,
      primary: AfiaColors.primary,
      onPrimary: AfiaColors.onPrimary,
      primaryContainer: AfiaColors.primaryContainer,
      onPrimaryContainer: AfiaColors.onPrimaryContainer,
      surface: AfiaColors.surface,
      onSurface: AfiaColors.onSurface,
      error: AfiaColors.red,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      canvasColor: Colors.transparent,
      scaffoldBackgroundColor: AfiaColors.scaffoldBackground,
      fontFamily: AfiaTypography.fontFamily,
      textTheme: AfiaTypography.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AfiaColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AfiaTypography.screenTitle,
        iconTheme: const IconThemeData(color: AfiaColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AfiaColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      iconTheme: const IconThemeData(color: AfiaColors.textPrimary),
      dividerTheme: const DividerThemeData(
        color: AfiaColors.divider,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AfiaColors.primary,
          foregroundColor: AfiaColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AfiaSpacing.xl,
            vertical: AfiaSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AfiaRadius.pill),
          ),
          textStyle: AfiaTypography.cardTitle.copyWith(color: Colors.white),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AfiaColors.primary,
        unselectedItemColor: AfiaColors.textMuted,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
