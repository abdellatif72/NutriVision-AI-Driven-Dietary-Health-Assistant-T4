import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Onboarding',
      description: 'Intro, profile setup, and guided onboarding flow screens live here.',
    );
  }
}
