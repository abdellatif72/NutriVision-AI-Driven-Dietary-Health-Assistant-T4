import 'package:flutter/material.dart';
import 'afia_colors.dart';

/// Type scale extracted from the Afia UI reference.
///
/// The reference uses a rounded, geometric sans with very bold,
/// tightly-tracked numerals for the big stat values ("1250", "5,500",
/// "12"). The default here points at the system font so this file
/// compiles with zero extra dependencies — swap [fontFamily] for a
/// font like "Plus Jakarta Sans", "Sora" or "Lexend" (via the
/// `google_fonts` package) to match the reference more closely:
///
/// ```dart
/// static String? fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
/// ```
class AfiaTypography {
  AfiaTypography._();

  static String? fontFamily; // null = platform default

  /// The big hero numbers: "1250", "5,500", "12", "86".
  static TextStyle get statValue => TextStyle(
        fontFamily: fontFamily,
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.5,
        color: AfiaColors.textPrimary,
      );

  /// Slightly smaller hero number, used inside the progress ring ("6").
  static TextStyle get statValueCompact => statValue.copyWith(fontSize: 24);

  /// Unit suffix next to a hero number: "Kcal", "steps", "glass", "days".
  static TextStyle get unit => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AfiaColors.textSecondary,
      );

  /// Screen titles: "Statistic".
  static TextStyle get screenTitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AfiaColors.textPrimary,
      );

  /// Card / section titles: "Calories", "Your Weekly Progress", "Breakfast".
  static TextStyle get cardTitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AfiaColors.textPrimary,
      );

  /// Small uppercase-ish eyebrow label: "Daily intake", "Step to walk".
  static TextStyle get label => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AfiaColors.textSecondary,
      );

  /// Body text: greeting, meal calorie range.
  static TextStyle get body => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AfiaColors.textPrimary,
      );

  /// Smallest text: bar chart percentages, weekday letters.
  static TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AfiaColors.textMuted,
      );

  static TextStyle get greetingName => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AfiaColors.textPrimary,
      );

  static TextTheme get textTheme => TextTheme(
        headlineMedium: statValue,
        titleLarge: screenTitle,
        titleMedium: cardTitle,
        bodyMedium: body,
        bodySmall: label,
        labelSmall: caption,
      );
}
