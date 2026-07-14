import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MoreTile extends StatelessWidget {
  const MoreTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: 2,
      ),
      leading: Icon(icon, color: AfiaColors.textSecondary, size: 22),
      title: Text(title, style: AfiaTypography.cardTitle),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AfiaTypography.body)
          : null,
      trailing: Icon(
        isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        color: AfiaColors.textMuted,
      ),
    );
  }
}
