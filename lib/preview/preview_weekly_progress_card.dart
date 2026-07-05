import 'package:afia/core/widgets/afia_weekly_progress_card.dart';
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
        appBar: AppBar(title: const Text('Weekly Progress Card Preview')),
        body: const Padding(
          padding: EdgeInsets.all(AfiaSpacing.pageMargin),
          child: Column(
            children: [
              AfiaWeeklyProgressCard(
                title: 'Your Weekly\nProgress',
                eyebrow: 'Daily intake',
                completed: 6,
                total: 7,
              ),
              SizedBox(height: AfiaSpacing.xl),
              AfiaWeeklyProgressCard(
                title: 'Water\nGoal Streak',
                eyebrow: 'Hydration',
                completed: 4,
                total: 7,
              ),
              SizedBox(height: AfiaSpacing.xl),
              AfiaWeeklyProgressCard(
                title: 'Exercise\nThis Week',
                eyebrow: 'Workouts',
                eyebrowIcon: Icons.fitness_center_rounded,
                completed: 3,
                total: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
