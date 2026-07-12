import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MealDateSelector extends StatelessWidget {
  const MealDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  String _formatDate(BuildContext context, DateTime date) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate == today) {
      return isAr ? 'اليوم' : 'Today';
    } else if (compareDate == yesterday) {
      return isAr ? 'أمس' : 'Yesterday';
    } else if (compareDate == tomorrow) {
      return isAr ? 'غداً' : 'Tomorrow';
    }

    if (isAr) {
      final weekday = _weekdaysAr[date.weekday - 1];
      final month = _monthsAr[date.month - 1];
      return '$weekday، ${date.day} $month';
    } else {
      final weekday = _weekdaysEn[date.weekday - 1];
      final month = _monthsEn[date.month - 1];
      return '$weekday, $month ${date.day}';
    }
  }

  static const _weekdaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthsEn = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const _weekdaysAr = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
  static const _monthsAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AfiaSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => onDateChanged(selectedDate.subtract(const Duration(days: 1))),
            icon: Icon(isAr ? Icons.chevron_right_rounded : Icons.chevron_left_rounded),
            color: AfiaColors.textPrimary,
          ),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AfiaColors.primary,
                        onPrimary: Colors.white,
                        onSurface: AfiaColors.textPrimary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onDateChanged(picked);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AfiaSpacing.md, vertical: AfiaSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AfiaColors.primary,
                  ),
                  const SizedBox(width: AfiaSpacing.sm),
                  Text(
                    _formatDate(context, selectedDate),
                    style: AfiaTypography.cardTitle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => onDateChanged(selectedDate.add(const Duration(days: 1))),
            icon: Icon(isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded),
            color: AfiaColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
