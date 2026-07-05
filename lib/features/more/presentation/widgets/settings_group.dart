import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';
import 'package:afia/features/more/presentation/widgets/more_section_card.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AfiaSpacing.sm,
            bottom: AfiaSpacing.sm,
          ),
          child: Text(title, style: AfiaTypography.label),
        ),
        MoreSectionCard(children: children),
      ],
    );
  }
}
