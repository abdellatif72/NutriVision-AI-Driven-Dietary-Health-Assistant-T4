import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class TodaysMealsList extends StatelessWidget {
  const TodaysMealsList({super.key, required this.meals, this.onMealTap});

  final List<MealEntry> meals;
  final ValueChanged<MealEntry>? onMealTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'وجبات اليوم'
                : "Today's Meals",
            style: AfiaTypography.cardTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AfiaColors.textPrimary,
            ),
          ),
        ),
        ...meals.map((meal) => _MealRow(meal: meal, onTap: onMealTap != null ? () => onMealTap!(meal) : null)),
      ],
    );
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({required this.meal, this.onTap});

  final MealEntry meal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final logged = meal.isLogged;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    String title = meal.title;
    if (isAr) {
      if (title.toLowerCase() == 'breakfast') title = 'الفطور';
      if (title.toLowerCase() == 'lunch') title = 'الغداء';
      if (title.toLowerCase() == 'dinner') title = 'العشاء';
      if (title.toLowerCase() == 'snack') title = 'وجبة خفيفة';
    }

    String? description = meal.description;
    if (isAr && description != null) {
      if (description == 'Oatmeal with berries') description = 'شوفان بالتوت البري';
      if (description == 'Koshari + salad') description = 'كشري مع سلطة';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
                      title,
                      style: AfiaTypography.cardTitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    if (logged && description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        description,
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
                      logged
                          ? (Localizations.localeOf(context).languageCode == 'ar'
                              ? '${meal.calories} سعرة حرارية'
                              : '${meal.calories} kcal')
                          : (Localizations.localeOf(context).languageCode == 'ar'
                              ? 'لم تسجل بعد'
                              : 'Not logged yet'),
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
              // Chevron or Add button
              if (logged)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AfiaColors.textMuted,
                    ),
                  ],
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
        ),
      ),
    );
  }
}
