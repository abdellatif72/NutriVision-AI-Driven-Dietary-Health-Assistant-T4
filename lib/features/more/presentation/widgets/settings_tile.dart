import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: 2,
      ),
      leading: Icon(icon, color: AfiaColors.textSecondary, size: 22),
      title: Text(title, style: AfiaTypography.cardTitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: AfiaSpacing.sm),
              child: Text(
                trailing!,
                style: AfiaTypography.body.copyWith(
                  color: AfiaColors.textSecondary,
                ),
              ),
            ),
          const Icon(Icons.chevron_right_rounded, color: AfiaColors.textMuted),
        ],
      ),
    );
  }
}
