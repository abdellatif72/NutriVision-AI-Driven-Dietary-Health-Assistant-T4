import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class MoreProfileCard extends StatelessWidget {
  const MoreProfileCard({
    required this.name,
    required this.initials,
    required this.currentGoal,
    required this.streakDays,
    required this.onTap,
    super.key,
  });

  final String name;
  final String initials;
  final String currentGoal;
  final int streakDays;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    
    // Map goal key to localized title
    String goalText = currentGoal;
    final lowerGoal = currentGoal.toLowerCase();
    if (lowerGoal == 'stay_healthy' || lowerGoal == 'stay healthy' || lowerGoal == 'maintain') {
      goalText = isAr ? 'البقاء بصحة جيدة' : 'Stay Healthy';
    } else if (lowerGoal == 'lose_weight' || lowerGoal == 'lose weight' || lowerGoal == 'lose') {
      goalText = isAr ? 'إنقاص الوزن' : 'Lose Weight';
    } else if (lowerGoal == 'build_muscle' || lowerGoal == 'build muscle' || lowerGoal == 'gain') {
      goalText = isAr ? 'بناء العضلات' : 'Build Muscle';
    } else if (lowerGoal == 'nutrition' || lowerGoal == 'improve_nutrition') {
      goalText = isAr ? 'تحسين التغذية' : 'Improve Nutrition';
    }

    final streakText = isAr 
        ? 'متابعة لـ $streakDays يوم متتالي' 
        : '$streakDays day streak';

    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AfiaColors.primaryContainer,
                child: Text(
                  initials,
                  style: AfiaTypography.cardTitle.copyWith(
                    color: AfiaColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AfiaTypography.cardTitle),
                    const SizedBox(height: 4),
                    Text(
                      '$goalText • $streakText',
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                color: AfiaColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
