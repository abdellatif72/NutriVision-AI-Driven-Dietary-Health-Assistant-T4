import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_bottom_section.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_hero_text.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_illustration.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_logo.dart';
import 'package:afia/app/localization/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// First screen the user sees. A visual welcome introducing the Afia
/// brand and value proposition, with a CTA to start onboarding or log in.
class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AfiaSpacing.pageMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AfiaSpacing.sm),

              // Language Toggle Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      final isAr = Localizations.localeOf(context).languageCode == 'ar';
                      context.read<LocaleCubit>().setLocale(isAr ? 'en' : 'ar');
                    },
                    icon: const Icon(
                      Icons.language_rounded,
                      color: AfiaColors.primary,
                      size: 18,
                    ),
                    label: Text(
                      Localizations.localeOf(context).languageCode == 'ar' ? 'English' : 'عربي',
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AfiaRadius.pill),
                        side: const BorderSide(color: AfiaColors.primary, width: 1.2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AfiaSpacing.sm),

              // ── Afia branding logo ──
              const OnboardLogo(height: 130),

              const SizedBox(height: AfiaSpacing.xxl),

              // ── Headline + subtitle ──
              const OnboardHeroText(),

              // ── Central illustration (expands to fill) ──
              const Expanded(child: Center(child: OnboardIllustration())),

              // ── Bottom CTA area ──
              OnboardBottomSection(
                onGetStarted: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteNames.authSignup,
                    arguments: true,
                  );
                },
                onLogIn: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteNames.authLogin,
                    arguments: true,
                  );
                },
              ),

              const SizedBox(height: AfiaSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
