import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Main',
      description: 'Home, path, and progress entry points live here.',
    );
  }
}
