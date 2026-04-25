import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'More',
      description: 'Account, settings, alerts, goals, help, and logout live here.',
    );
  }
}
