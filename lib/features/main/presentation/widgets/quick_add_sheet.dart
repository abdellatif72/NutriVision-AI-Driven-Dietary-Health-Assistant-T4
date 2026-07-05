import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:flutter/material.dart';

Future<void> showQuickAddSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _QuickAddSheet(),
  );
}

class _QuickAddSheet extends StatelessWidget {
  const _QuickAddSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AfiaColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Add new',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AfiaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _QuickAddOption(
              icon: '📸',
              title: 'Film your food',
              subtitle: 'AI will recognize food and calculate calories',
              filled: true,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            _QuickAddOption(
              icon: '📝',
              title: 'Manual recording',
              subtitle: 'Write the name of the food and the calories yourself',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.mealSearch);
              },
            ),
            const SizedBox(height: 8),
            _QuickAddOption(
              icon: '💧',
              title: 'Record water',
              subtitle: 'Quick registration (cup, pint, or custom)',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.water);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddOption extends StatelessWidget {
  const _QuickAddOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AfiaColors.orange : AfiaColors.scaffoldBackground;
    final border = filled ? AfiaColors.orange : AfiaColors.divider;
    final titleColor = filled ? Colors.white : AfiaColors.textPrimary;
    final subtitleColor =
        filled ? Colors.white.withValues(alpha: 0.85) : AfiaColors.textSecondary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
