import 'package:flutter/material.dart';
import '../theme/afia_colors.dart';
import '../theme/afia_spacing.dart';
import '../theme/afia_typography.dart';
/// The "Calories" card from the Statistics screen: a big value + target,
/// and a 7-bar week chart with a percentage label above each bar and
/// the current/peak day highlighted in solid green.
///
/// Deliberately built with plain [Container]s instead of a charting
/// package — it's 7 fixed bars, not a general-purpose chart, so this
/// keeps the design system dependency-free. Swap in `fl_chart` later
/// if you need richer interactions (tooltips, scrubbing, etc).
class AfiaWeeklyBarChartCard extends StatelessWidget {
  const AfiaWeeklyBarChartCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.target,
    required this.bars,
    required this.highlightedIndex,
  });

  final String title; // "Calories"
  final String value; // "1250"
  final String unit; // "Kcal"
  final String target; // "Target: 1920 Kcal"

  /// One entry per day: {'label': 'Mon', 'percent': 44}.
  final List<({String label, int percent})> bars;
  final int highlightedIndex;

  @override
  Widget build(BuildContext context) {
    final maxPercent = bars.map((b) => b.percent).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.xl),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AfiaTypography.cardTitle),
          const SizedBox(height: AfiaSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AfiaTypography.statValue),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(unit, style: AfiaTypography.unit),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(target, style: AfiaTypography.label),
              ),
            ],
          ),
          const SizedBox(height: AfiaSpacing.xl),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(bars.length, (i) {
                final bar = bars[i];
                final isPeak = i == highlightedIndex;
                final heightFraction = bar.percent / maxPercent;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${bar.percent}%', style: AfiaTypography.caption),
                        const SizedBox(height: AfiaSpacing.sm),
                        Container(
                          height: 90 * heightFraction,
                          decoration: BoxDecoration(
                            color: isPeak ? AfiaColors.green500 : AfiaColors.trackInactive,
                            borderRadius: BorderRadius.circular(AfiaSpacing.sm),
                          ),
                        ),
                        const SizedBox(height: AfiaSpacing.sm),
                        Text(
                          bar.label,
                          style: AfiaTypography.caption.copyWith(
                            color: isPeak ? AfiaColors.textPrimary : AfiaColors.textMuted,
                            fontWeight: isPeak ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
