import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeaturePlaceholderPage(
        title: 'Meals',
        description:
            'Meal logging, registration, editing, and saved meals live here. '
            'This page will contain the complete meal tracking flow.',
      ),
    );
  }
}
