import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:flutter/material.dart';

class CaloriesBarChart extends StatelessWidget {
  const CaloriesBarChart({
    super.key,
    required this.caption,
    required this.bars,
  });

  final String caption;
  final List<ChartBar> bars;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AfiaColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: const TextStyle(
              fontSize: 11,
              color: AfiaColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (b) => Expanded(
                      child: _BarColumn(bar: b),
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
  const _BarColumn({required this.bar});

  final ChartBar bar;

  @override
  Widget build(BuildContext context) {
    final color =
        bar.emphasized ? AfiaColors.primary : AfiaColors.primary.withValues(alpha: 0.45);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (bar.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              bar.value,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
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
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          bar.label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AfiaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
