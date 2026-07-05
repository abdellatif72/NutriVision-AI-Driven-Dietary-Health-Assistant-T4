import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MealQuickActions extends StatelessWidget {
  const MealQuickActions({
    super.key,
    required this.onAddMealTap,
    required this.onSavedMealsTap,
  });

  final VoidCallback onAddMealTap;
  final VoidCallback onSavedMealsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAddMealTap,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add meal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AfiaColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: AfiaTypography.body.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: AfiaSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSavedMealsTap,
            icon: const Icon(Icons.bookmark_outline_rounded, size: 18),
            label: const Text('Saved meals'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AfiaColors.textPrimary,
              side: const BorderSide(color: AfiaColors.divider),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: AfiaTypography.body.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
