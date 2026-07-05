import 'package:afia/core/theme/afia_colors.dart';
import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  const FormCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: Column(children: children),
    );
  }
}
