import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Meals',
      description: 'Meal logging, registration, editing, and saved meals live here.',
    );
  }
}
