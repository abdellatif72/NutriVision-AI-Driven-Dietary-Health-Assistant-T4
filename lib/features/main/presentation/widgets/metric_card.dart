import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.kind,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtext,
    this.valueUnit,
    this.onTap,
  });

  final AfiaMetricKind kind;
  final IconData icon;
  final String title;
  final String value;
  final String? valueUnit;
  final String subtext;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (accent, container) = AfiaColors.accentFor(kind);

    // Subtle background tint for each card based on its metric type
    Color cardBgColor;
    switch (kind) {
      case AfiaMetricKind.steps:
        cardBgColor = const Color(0xFFFFF6F0); // Very soft peach
        break;
      case AfiaMetricKind.water:
        cardBgColor = const Color(0xFFF2F8FF); // Very soft blue
        break;
      default:
        cardBgColor = AfiaColors.surface;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Chip
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  title,
                  style: AfiaTypography.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AfiaColors.textPrimary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                // Value & Unit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: AfiaTypography.statValueCompact.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AfiaColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (valueUnit != null) ...[
                      const SizedBox(width: 2),
                      Text(
                        valueUnit!,
                        style: AfiaTypography.unit.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AfiaColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                // Subtext / Goal
                Text(
                  subtext,
                  style: AfiaTypography.caption.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
