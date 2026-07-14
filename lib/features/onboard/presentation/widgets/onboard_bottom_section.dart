import 'package:afia/app/localization/l10n.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

/// CTA area: "Get Started" button, "Already have an account? Log in",
/// and 3 static page-indicator dots.
class OnboardBottomSection extends StatelessWidget {
  const OnboardBottomSection({
    required this.onGetStarted,
    required this.onLogIn,
    super.key,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Get Started" CTA button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: onGetStarted,
            style: ElevatedButton.styleFrom(
              backgroundColor: AfiaColors.primary,
              foregroundColor: AfiaColors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AfiaRadius.xl),
              ),
              textStyle: AfiaTypography.cardTitle.copyWith(color: Colors.white),
            ),
            child: Text(l.getStarted),
          ),
        ),

        const SizedBox(height: AfiaSpacing.lg),

        // "Already have an account? Log in"
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l.alreadyHaveAccount,
              style: AfiaTypography.body.copyWith(
                color: AfiaColors.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: onLogIn,
              child: Text(
                l.logIn,
                style: AfiaTypography.body.copyWith(
                  color: AfiaColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AfiaSpacing.xl),

        // Page indicator dots (static — page 1 of 3)
        const _PageDots(activeIndex: 0, count: 3),

        const SizedBox(height: AfiaSpacing.sm),
      ],
    );
  }
}

/// Three small dots with the active one in primary green.
class _PageDots extends StatelessWidget {
  const _PageDots({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AfiaColors.primary : AfiaColors.trackInactive,
            borderRadius: BorderRadius.circular(AfiaRadius.pill),
          ),
        );
      }),
    );
  }
}
