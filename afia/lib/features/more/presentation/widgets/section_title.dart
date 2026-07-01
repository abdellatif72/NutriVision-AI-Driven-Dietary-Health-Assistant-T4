import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AfiaTypography.label.copyWith(color: AfiaColors.textPrimary),
    );
  }
}
