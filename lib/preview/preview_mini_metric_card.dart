import 'package:afia/core/widgets/afia_mini_metric_card.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:flutter/material.dart';

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AfiaColors.scaffoldBackground,
        appBar: AppBar(title: const Text('Mini Metric Card Preview')),
        body: const Padding(
          padding: EdgeInsets.all(AfiaSpacing.pageMargin),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AfiaMiniMetricCard(
                      kind: AfiaMetricKind.exercise,
                      icon: Icons.fitness_center_rounded,
                      label: 'Exercise',
                      value: '45',
                      unit: 'min',
                    ),
                  ),
                  SizedBox(width: AfiaSpacing.md),
                  Expanded(
                    child: AfiaMiniMetricCard(
                      kind: AfiaMetricKind.exercise,
                      icon: Icons.favorite_rounded,
                      label: 'BPM',
                      value: '86',
                      unit: 'bpm',
                      visual: AfiaSparkline(
                        values: [0.2, 0.5, 0.3, 0.7, 0.6, 0.9, 0.8],
                        color: AfiaColors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AfiaSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AfiaMiniMetricCard(
                      kind: AfiaMetricKind.water,
                      icon: Icons.water_drop_rounded,
                      label: 'Water',
                      value: '1.8',
                      unit: 'L',
                    ),
                  ),
                  SizedBox(width: AfiaSpacing.md),
                  Expanded(
                    child: AfiaMiniMetricCard(
                      kind: AfiaMetricKind.calories,
                      icon: Icons.monitor_weight_rounded,
                      label: 'Weight',
                      value: '74.2',
                      unit: 'kg',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
