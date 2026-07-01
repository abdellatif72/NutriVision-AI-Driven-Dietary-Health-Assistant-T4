import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
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
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(AfiaSpacing.lg),
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
                      '$currentGoal • $streakDays day streak',
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AfiaColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
