import 'package:afia/core/widgets/afia_metric_stat_card.dart';
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
        appBar: AppBar(title: const Text('Metric Stat Card Preview')),
        body: const Padding(
          padding: EdgeInsets.all(AfiaSpacing.pageMargin),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AfiaMetricStatCard(
                      kind: AfiaMetricKind.steps,
                      icon: Icons.directions_walk_rounded,
                      label: 'Step to walk',
                      value: '5,500',
                      unit: 'steps',
                    ),
                  ),
                  SizedBox(width: AfiaSpacing.md),
                  Expanded(
                    child: AfiaMetricStatCard(
                      kind: AfiaMetricKind.water,
                      icon: Icons.water_drop_rounded,
                      label: 'Drink Water',
                      value: '12',
                      unit: 'glass',
                    ),
                  ),
                ],
              ),
              SizedBox(height: AfiaSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AfiaMetricStatCard(
                      kind: AfiaMetricKind.calories,
                      icon: Icons.local_fire_department_rounded,
                      label: 'Calories Burned',
                      value: '1,850',
                      unit: 'kcal',
                    ),
                  ),
                  SizedBox(width: AfiaSpacing.md),
                  Expanded(
                    child: AfiaMetricStatCard(
                      kind: AfiaMetricKind.heartRate,
                      icon: Icons.favorite_rounded,
                      label: 'Resting HR',
                      value: '72',
                      unit: 'bpm',
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
