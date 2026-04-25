import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'AI',
      description: 'Recipe parsing, image analysis, and snack suggestions live here.',
    );
  }
}
