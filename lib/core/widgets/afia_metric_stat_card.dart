import 'package:flutter/material.dart';
import '../theme/afia_colors.dart';
import '../theme/afia_spacing.dart';
import '../theme/afia_typography.dart';

/// The small two-up cards on the home screen: an icon chip, a label,
/// and a big value + unit ("Step to walk" / "5,500 steps").
///
/// Usage:
/// ```dart
/// Row(
///   children: [
///     Expanded(child: AfiaMetricStatCard(
///       kind: AfiaMetricKind.steps,
///       icon: Icons.directions_walk_rounded,
///       label: 'Step to walk',
///       value: '5,500',
///       unit: 'steps',
///     )),
///     const SizedBox(width: AfiaSpacing.md),
///     Expanded(child: AfiaMetricStatCard(
///       kind: AfiaMetricKind.water,
///       icon: Icons.water_drop_rounded,
///       label: 'Drink Water',
///       value: '12',
///       unit: 'glass',
///     )),
///   ],
/// )
/// ```
class AfiaMetricStatCard extends StatelessWidget {
  const AfiaMetricStatCard({
    super.key,
    required this.kind,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.onTap,
  });

  final AfiaMetricKind kind;
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (accent, container) = AfiaColors.accentFor(kind);

    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(AfiaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: container,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(height: AfiaSpacing.md),
              Text(label, style: AfiaTypography.label),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: AfiaTypography.statValueCompact),
                  const SizedBox(width: 4),
                  Text(unit, style: AfiaTypography.unit),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
