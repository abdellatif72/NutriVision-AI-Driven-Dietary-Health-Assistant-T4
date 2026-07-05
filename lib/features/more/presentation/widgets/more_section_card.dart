import 'package:afia/core/theme/afia_colors.dart';
import 'package:flutter/material.dart';

class MoreSectionCard extends StatelessWidget {
  const MoreSectionCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i != 0)
              const Divider(height: 1, thickness: 1, color: AfiaColors.divider),
            children[i],
          ],
        ],
      ),
    );
  }
}
