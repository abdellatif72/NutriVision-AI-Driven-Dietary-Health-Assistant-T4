import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:flutter/material.dart';

class MealLogCard extends StatelessWidget {
  const MealLogCard({
    super.key,
    required this.slot,
    required this.onAddTap,
    required this.onMealTap,
  });

  final MealSlotDetail slot;
  final VoidCallback onAddTap;
  final ValueChanged<MealSummary> onMealTap;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Translate slot name
    String slotName = slot.name;
    if (isAr) {
      if (slotName.toLowerCase() == 'breakfast') slotName = 'الفطور';
      if (slotName.toLowerCase() == 'lunch') slotName = 'الغداء';
      if (slotName.toLowerCase() == 'dinner') slotName = 'العشاء';
      if (slotName.toLowerCase() == 'snack') slotName = 'وجبة خفيفة';
    }

    if (!slot.isLogged) {
      // Unlogged Slot Card
      return Container(
        margin: const EdgeInsets.only(bottom: AfiaSpacing.md),
        decoration: BoxDecoration(
          color: AfiaColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AfiaColors.divider),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAddTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(AfiaSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AfiaColors.trackInactive.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        slot.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: AfiaSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slotName,
                          style: AfiaTypography.cardTitle.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAr ? 'إضافة وجبة' : 'Add a meal',
                          style: AfiaTypography.body.copyWith(
                            fontSize: 12,
                            color: AfiaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AfiaColors.trackInactive,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AfiaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Logged meals (can be multiple)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: slot.loggedMeals.map((meal) {
        // Translate meal details
        String mealName = meal.name;
        String servingLabel = meal.servingLabel;

        if (isAr) {
          if (mealName == 'Oatmeal with berries') mealName = 'شوفان بالتوت البري';
          if (mealName == 'Koshari + salad') mealName = 'كشري مع سلطة';
          
          if (servingLabel == '1 bowl · 150g') servingLabel = 'زبدية واحدة · ١٥٠ غرام';
          if (servingLabel == '1 plate · 350g') servingLabel = 'طبق واحد · ٣٥٠ غرام';
          if (servingLabel.contains('serving')) {
            servingLabel = servingLabel.replaceAll('serving', 'حصة').replaceAll('1', '١').replaceAll('2', '٢');
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: AfiaSpacing.md),
          decoration: BoxDecoration(
            color: AfiaColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AfiaColors.divider),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onMealTap(meal),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(AfiaSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AfiaColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          meal.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: AfiaSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slotName,
                            style: AfiaTypography.cardTitle.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$mealName · $servingLabel',
                            style: AfiaTypography.body.copyWith(
                              fontSize: 12,
                              color: AfiaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isAr ? '${meal.calories} سعرة' : '${meal.calories} kcal',
                          style: AfiaTypography.caption.copyWith(
                            color: AfiaColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AfiaColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
