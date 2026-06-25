import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_bottom_section.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_hero_text.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_illustration.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_logo.dart';
import 'package:flutter/material.dart';


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
              const SizedBox(height: AfiaSpacing.xl),

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
                  Navigator.of(context).pushReplacementNamed(RouteNames.auth);
                },
                onLogIn: () {
                  Navigator.of(context).pushReplacementNamed(RouteNames.auth);
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
