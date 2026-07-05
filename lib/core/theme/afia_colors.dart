import 'package:flutter/material.dart';

/// Color tokens extracted from the Afia UI reference screens.
///
/// The reference uses one vibrant lime-green as the brand color, plus
/// three semantic accents — orange (steps / calories / energy), blue
/// (water / hydration) and red (heart rate) — each paired with a pale
/// "container" tint used behind icon chips.
class AfiaColors {
  AfiaColors._();

  // ---------------------------------------------------------------
  // Brand green scale
  // ---------------------------------------------------------------
  static const Color green50 = Color(0xFFF1F8E5);
  static const Color green100 = Color(0xFFDFF0C4); // "Weekly progress" card bg
  static const Color green200 = Color(0xFFC5E593);
  static const Color green300 = Color(0xFFA8D766);
  static const Color green400 = Color(0xFF93CC49);
  static const Color green500 = Color(0xFF7FBF2E); // primary / FAB / ring / peak bar
  static const Color green600 = Color(0xFF6BA824);
  static const Color green700 = Color(0xFF54861C);
  static const Color green800 = Color(0xFF3D6314);
  static const Color green900 = Color(0xFF27420C);

  static const Color primary = green500;
  static const Color primaryContainer = green100;
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = green800;

  // ---------------------------------------------------------------
  // Semantic accents (one per metric family)
  // ---------------------------------------------------------------
  static const Color orange = Color(0xFFFF8A3D); // steps, calories flame
  static const Color orangeContainer = Color(0xFFFFEADB);

  static const Color blue = Color(0xFF3DA5F4); // water
  static const Color blueContainer = Color(0xFFE2F2FE);

  static const Color red = Color(0xFFFF5C5C); // heart rate
  static const Color redContainer = Color(0xFFFFE3E3);

  // ---------------------------------------------------------------
  // Neutrals
  // ---------------------------------------------------------------
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFEFEFEF);

  /// Unfilled progress track / placeholder bars (the dashed grey bars
  /// in the calories chart use this at low opacity).
  static const Color trackInactive = Color(0xFFE7EAE2);

  static const Color scaffoldBackground = Color(0xFFF7F8F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = textPrimary;

  /// Maps a metric "kind" to its accent + container pair so cards can
  /// stay data-driven instead of hardcoding colors per screen.
  static (Color accent, Color container) accentFor(AfiaMetricKind kind) {
    switch (kind) {
      case AfiaMetricKind.steps:
      case AfiaMetricKind.calories:
        return (orange, orangeContainer);
      case AfiaMetricKind.water:
        return (blue, blueContainer);
      case AfiaMetricKind.heartRate:
        return (red, redContainer);
      case AfiaMetricKind.exercise:
        return (primary, primaryContainer);
    }
  }
}

enum AfiaMetricKind { steps, water, calories, heartRate, exercise }
