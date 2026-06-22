import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:flutter/material.dart';

class MealSearchTile extends StatelessWidget {
  const MealSearchTile({
    super.key,
    required this.meal,
    required this.onTap,
  });

  final MealSummary meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AfiaColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AfiaColors.divider),
              ),
              child: Text(meal.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AfiaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meal.servingLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AfiaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AfiaColors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${meal.calories} kcal',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AfiaColors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
