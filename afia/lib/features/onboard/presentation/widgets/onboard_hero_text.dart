import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

/// "Healthy habits, smarter you." heading + subtitle paragraph, centered.
class OnboardHeroText extends StatelessWidget {
  const OnboardHeroText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Healthy habits,\nsmarter you.',
          textAlign: TextAlign.center,
          style: AfiaTypography.statValue.copyWith(
            fontSize: 28,
            height: 1.2,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: AfiaSpacing.sm),
        Text(
          'Nutrition, activity, and AI insights\n— all in one place.',
          textAlign: TextAlign.center,
          style: AfiaTypography.body.copyWith(
            color: AfiaColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
