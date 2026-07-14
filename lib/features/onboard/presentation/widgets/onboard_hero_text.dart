import 'package:afia/app/localization/l10n.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Healthy habits, smarter you." heading + subtitle paragraph, centered.
class OnboardHeroText extends StatelessWidget {
  const OnboardHeroText({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l.healthyHabitsSmarterYou,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 28,
            height: 1.2,
            letterSpacing: -0.3,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AfiaSpacing.sm),
        Text(
          l.onboardSubtitle,
          textAlign: TextAlign.center,
          style: AfiaTypography.body.copyWith(
            color: AfiaColors.textPrimary,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
