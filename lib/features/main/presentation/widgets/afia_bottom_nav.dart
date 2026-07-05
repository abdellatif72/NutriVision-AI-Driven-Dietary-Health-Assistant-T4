import 'package:flutter/material.dart';
import '../../../../core/theme/afia_colors.dart';

/// Bottom nav matching the reference: 4 regular items (Home, Meals,
/// Chat, More) plus a 5th circular FAB-style item that sits centered
/// and slightly raised above the bar.
///
/// [items] should contain exactly 4 entries; the FAB is supplied
/// separately via [centerIcon] / [onCenterTap] since it behaves
/// differently (no label, no selected state, always green).
class AfiaBottomNav extends StatelessWidget {
  const AfiaBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.centerIcon,
    this.onCenterTap,
  });

  final List<AfiaNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final IconData centerIcon;
  final VoidCallback? onCenterTap;

  @override
  Widget build(BuildContext context) {
    final mid = items.length ~/ 2;

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            top: 12,
            child: Container(
              decoration: BoxDecoration(
                color: AfiaColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 18,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    if (i == mid) const Spacer(flex: 2),
                    Expanded(
                      flex: 3,
                      child: _NavTab(
                        item: items[i],
                        selected: i == selectedIndex,
                        onTap: () => onSelected(i),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCenterTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AfiaColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(centerIcon, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AfiaNavItem {
  const AfiaNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AfiaNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AfiaColors.primary : AfiaColors.textMuted;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 23, color: color),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
