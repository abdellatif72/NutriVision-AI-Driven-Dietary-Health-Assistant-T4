import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Meals",
                style: AfiaTypography.cardTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AfiaColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AfiaColors.primary,
                  ),
                ),
              ),
            ],
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AfiaColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Meal Image or Emoji Container
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AfiaColors.trackInactive.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: meal.imagePath != null
                ? Image.asset(
                    meal.imagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          meal.emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      meal.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          // Meal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.title,
                  style: AfiaTypography.cardTitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AfiaColors.textPrimary,
                  ),
                ),
                if (logged && meal.description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    meal.description!,
                    style: AfiaTypography.body.copyWith(
                      fontSize: 12,
                      color: AfiaColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 3),
                Text(
                  logged ? '${meal.calories} kcal' : 'Not logged yet',
                  style: AfiaTypography.caption.copyWith(
                    fontSize: 11,
                    color: logged ? AfiaColors.textMuted : AfiaColors.textSecondary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Check or Add button
          if (logged)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AfiaColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            )
          else
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AfiaColors.trackInactive,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 14,
                color: AfiaColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
