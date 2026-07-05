import 'package:flutter/material.dart';
import '../theme/afia_colors.dart';
import '../theme/afia_spacing.dart';
import '../theme/afia_typography.dart';

/// The big light-green hero card on the home screen: an eyebrow chip
/// ("Daily intake"), a two-line title ("Your Weekly Progress"), and a
/// circular progress ring showing "6 days" out of [total].
class AfiaWeeklyProgressCard extends StatelessWidget {
  const AfiaWeeklyProgressCard({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.completed,
    required this.total,
    this.eyebrowIcon = Icons.bolt_rounded,
  });

  final String title;
  final String eyebrow;
  final IconData eyebrowIcon;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.xl),
      decoration: BoxDecoration(
        color: AfiaColors.green100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AfiaSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AfiaColors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AfiaRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(eyebrowIcon, size: 13, color: AfiaColors.green700),
                      const SizedBox(width: 4),
                      Text(
                        eyebrow,
                        style: AfiaTypography.caption.copyWith(
                          color: AfiaColors.green700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AfiaSpacing.md),
                Text(
                  title,
                  style: AfiaTypography.cardTitle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0, 1),
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AfiaColors.surface.withValues(alpha: 0.7),
                    valueColor: const AlwaysStoppedAnimation(AfiaColors.green500),
                  ),
                ),
                Text('$completed', style: AfiaTypography.statValueCompact),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
