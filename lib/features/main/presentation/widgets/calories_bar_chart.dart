import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:flutter/material.dart';

class CaloriesBarChart extends StatelessWidget {
  const CaloriesBarChart({
    super.key,
    required this.caption,
    required this.bars,
    this.barColor,
  });

  final String caption;
  final List<ChartBar> bars;
  final Color? barColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        0,
        AfiaSpacing.pageMargin,
        AfiaSpacing.md,
      ),
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(AfiaRadius.md),
        border: Border.all(color: AfiaColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(caption, style: AfiaTypography.label),
          const SizedBox(height: AfiaSpacing.md),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (b) => Expanded(
                      child: _BarColumn(bar: b, barColor: barColor),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({required this.bar, this.barColor});

  final ChartBar bar;
  final Color? barColor;

  @override
  Widget build(BuildContext context) {
    final base = barColor ?? AfiaColors.primary;
    final color = bar.emphasized ? base : base.withValues(alpha: 0.45);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (bar.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AfiaSpacing.xs),
            child: Text(
              bar.value,
              style: AfiaTypography.caption.copyWith(
                fontSize: 9,
                color: AfiaColors.textSecondary,
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: (bar.heightPercent.clamp(0.0, 1.0)) * 80 + 2,
          decoration: BoxDecoration(
            color: bar.heightPercent <= 0 ? AfiaColors.divider : color,
            borderRadius: BorderRadius.circular(AfiaRadius.sm),
          ),
        ),
        const SizedBox(height: AfiaSpacing.sm),
        Text(bar.label, style: AfiaTypography.caption),
      ],
    );
  }
}
