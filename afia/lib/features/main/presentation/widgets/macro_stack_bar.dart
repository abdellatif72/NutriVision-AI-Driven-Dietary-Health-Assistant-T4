import 'package:afia/core/theme/afia_colors.dart';
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
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AfiaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: List.generate(macros.length, (i) {
                  final flex = (macros[i].fillPercent * 100).round().clamp(1, 100);
                  return Expanded(
                    flex: flex,
                    child: Container(color: _colors[i % _colors.length]),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
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
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AfiaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
