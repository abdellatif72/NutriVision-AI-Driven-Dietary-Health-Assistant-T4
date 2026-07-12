import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MealAiSuggestionCard extends StatelessWidget {
  const MealAiSuggestionCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AfiaColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AfiaSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AfiaColors.orangeContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AfiaColors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AfiaSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'هل تحتاج إلى إلهام؟' : 'Need inspiration?',
                        style: AfiaTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAr
                            ? 'جرّب اقتراح وجبة سريع من مساعد عافية الذكي.'
                            : 'Try a quick meal suggestion from Afia AI.',
                        style: AfiaTypography.body.copyWith(
                          fontSize: 12,
                          color: AfiaColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                  color: AfiaColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
