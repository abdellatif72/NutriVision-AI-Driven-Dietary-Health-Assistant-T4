import 'package:flutter/material.dart';
import '../theme/afia_colors.dart';
import '../theme/afia_spacing.dart';
import '../theme/afia_typography.dart';

/// The "August 2025" week strip: a month header with prev/next arrows,
/// then a row of weekday letters with the date underneath, the
/// selected day highlighted as a filled green circle.
///
/// Built with [Directionality]-agnostic widgets (Row + MainAxisAlignment)
/// so it mirrors correctly under RTL without any extra work.
class AfiaWeekCalendar extends StatelessWidget {
  const AfiaWeekCalendar({
    super.key,
    required this.monthLabel,
    required this.days,
    required this.selectedIndex,
    required this.onSelected,
    this.onPrevious,
    this.onNext,
  });

  final String monthLabel;

  /// One entry per visible day, e.g. {'weekday': 'W', 'date': '10'}.
  final List<({String weekday, String date})> days;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(monthLabel, style: AfiaTypography.cardTitle),
              ),
              _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
              const SizedBox(width: AfiaSpacing.sm),
              _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext),
            ],
          ),
          const SizedBox(height: AfiaSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (i) {
              final selected = i == selectedIndex;
              final day = days[i];
              return _DayChip(
                weekday: day.weekday,
                date: day.date,
                selected: selected,
                onTap: () => onSelected(i),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.weekday,
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final String weekday;
  final String date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            weekday,
            style: AfiaTypography.caption.copyWith(
              color: selected ? AfiaColors.textPrimary : AfiaColors.textMuted,
            ),
          ),
          const SizedBox(height: AfiaSpacing.sm),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AfiaColors.green200 : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              date,
              style: AfiaTypography.body.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AfiaColors.scaffoldBackground,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 18, color: AfiaColors.textSecondary),
        ),
      ),
    );
  }
}
