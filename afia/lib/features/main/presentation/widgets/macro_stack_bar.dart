import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class MacroStackBar extends StatelessWidget {
  const MacroStackBar({super.key, required this.macros, required this.title});

  final List<MacroSummary> macros;
  final String title;

  static const _colors = <Color>[
    AfiaColors.primary,
    AfiaColors.green700,
    AfiaColors.orange,
  ];

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
          Text(title, style: AfiaTypography.cardTitle),
          const SizedBox(height: AfiaSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AfiaRadius.sm),
            child: SizedBox(
              height: 8,
              child: Row(
                children: List.generate(macros.length, (i) {
                  final flex = (macros[i].fillPercent * 100).round().clamp(
                    1,
                    100,
                  );
                  return Expanded(
                    flex: flex,
                    child: Container(color: _colors[i % _colors.length]),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: AfiaSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(macros.length, (i) {
              return _Legend(
                color: _colors[i % _colors.length],
                label: '${macros[i].label} ${macros[i].grams}g',
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AfiaSpacing.xs),
        Text(label, style: AfiaTypography.caption),
      ],
    );
  }
}
