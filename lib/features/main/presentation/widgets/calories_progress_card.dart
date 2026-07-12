import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class CaloriesProgressCard extends StatelessWidget {
  const CaloriesProgressCard({
    super.key,
    required this.consumed,
    required this.goal,
    this.onTap,
  });

  final int consumed;
  final int goal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final percent = goal <= 0 ? 0.0 : (consumed / goal).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AfiaColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Flame Icon Chip
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AfiaColors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AfiaColors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Calories Text info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'السعرات الحرارية'
                                : 'Calories',
                            style: AfiaTypography.label.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AfiaColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$consumed',
                                style: AfiaTypography.statValueCompact.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AfiaColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Localizations.localeOf(context).languageCode == 'ar'
                                    ? '/ $goal سعرة حرارية'
                                    : '/ $goal kcal',
                                style: AfiaTypography.unit.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AfiaColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 7,
                    backgroundColor: AfiaColors.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AfiaColors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
