import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class TodaysMealsList extends StatelessWidget {
  const TodaysMealsList({super.key, required this.meals});

  final List<MealEntry> meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            "Today's meals",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AfiaColors.textPrimary,
            ),
          ),
        ),
        ...meals.map((meal) => _MealRow(meal: meal)),
      ],
    );
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({required this.meal});

  final MealEntry meal;

  @override
  Widget build(BuildContext context) {
    final logged = meal.isLogged;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AfiaColors.divider),
      ),
      child: Row(
        children: [
          Text(meal.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AfiaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  logged
                      ? '${meal.description ?? ''} · ${meal.calories} cal'
                      : '0 cal',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (logged)
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AfiaColors.textSecondary,
            )
          else
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AfiaColors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
