import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MealsSummaryCard extends StatelessWidget {
  const MealsSummaryCard({
    super.key,
    required this.mealsLoggedCount,
    required this.mealsTotalCount,
    required this.consumedCalories,
    required this.calorieGoal,
    required this.remainingCalories,
    required this.progress,
    required this.carbs,
    required this.carbsGoal,
    required this.protein,
    required this.proteinGoal,
    required this.fat,
    required this.fatGoal,
  });

  final int mealsLoggedCount;
  final int mealsTotalCount;
  final int consumedCalories;
  final int calorieGoal;
  final int remainingCalories;
  final double progress;
  final int carbs;
  final int carbsGoal;
  final int protein;
  final int proteinGoal;
  final int fat;
  final int fatGoal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AfiaColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today’s meals',
                      style: AfiaTypography.cardTitle.copyWith(
                        color: AfiaColors.onPrimaryContainer,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xs),
                    Text(
                      '$mealsLoggedCount of $mealsTotalCount meals logged',
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.md),
                    Text(
                      '$consumedCalories kcal',
                      style: AfiaTypography.statValue.copyWith(
                        fontSize: 28,
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xs),
                    Text(
                      'Goal: $calorieGoal kcal · $remainingCalories left',
                      style: AfiaTypography.label.copyWith(
                        color: AfiaColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AfiaSpacing.md),
              // Circular progress indicator with remaining / avatar emoji
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: AfiaColors.trackInactive.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(AfiaColors.primary),
                    ),
                  ),
                  const Text(
                    '🥑',
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AfiaSpacing.lg),
          const Divider(color: AfiaColors.divider, height: 1),
          const SizedBox(height: AfiaSpacing.md),
          // Macro Mini-Summary Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _MacroProgress(
                  label: 'Carbs',
                  value: carbs,
                  goal: carbsGoal,
                  color: AfiaColors.primary,
                ),
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: _MacroProgress(
                  label: 'Protein',
                  value: protein,
                  goal: proteinGoal,
                  color: AfiaColors.orange,
                ),
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: _MacroProgress(
                  label: 'Fat',
                  value: fat,
                  goal: fatGoal,
                  color: AfiaColors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroProgress extends StatelessWidget {
  const _MacroProgress({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  final String label;
  final int value;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = goal <= 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AfiaTypography.caption.copyWith(
                color: AfiaColors.textSecondary,
                fontSize: 10,
              ),
            ),
            Text(
              '${value}g',
              style: AfiaTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AfiaColors.textPrimary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 4,
            backgroundColor: AfiaColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
