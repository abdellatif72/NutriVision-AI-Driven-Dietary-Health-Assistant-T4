/// Spacing and radius scale extracted from the Afia UI reference.
///
/// The reference reads as an 4pt-based grid: tight gaps between an
/// icon chip and its label (~8), comfortable card padding (~16-20),
/// and generous gaps between major sections (~20-24).
class AfiaSpacing {
  AfiaSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Default page margin (left/right inset of scrollable content).
  static const double pageMargin = 20;

  /// Vertical gap between major sections on a screen.
  static const double sectionGap = 20;
}

/// Corner radii. The reference favors large, soft rounding on cards
/// (~22-24) and full circles for icon chips / avatars / the FAB.
class AfiaRadius {
  AfiaRadius._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}
