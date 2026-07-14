import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class PeriodSegmentedControl extends StatelessWidget {
  const PeriodSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ProgressPeriod selected;
  final ValueChanged<ProgressPeriod> onChanged;

  String _localizedLabel(BuildContext context, ProgressPeriod p) {
    final l10n = AppLocalizations.of(context)!;
    switch (p) {
      case ProgressPeriod.week:
        return l10n.periodWeekly;
      case ProgressPeriod.month:
        return l10n.periodMonthly;
      case ProgressPeriod.year:
        return l10n.periodYearly;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(
        AfiaSpacing.pageMargin,
        0,
        AfiaSpacing.pageMargin,
        AfiaSpacing.md,
      ),
      padding: const EdgeInsetsDirectional.all(AfiaSpacing.xs),
      decoration: BoxDecoration(
        color: AfiaColors.divider,
        borderRadius: BorderRadius.circular(AfiaRadius.sm),
      ),
      child: Row(
        children: ProgressPeriod.values
            .map(
              (p) => Expanded(
                child: _SegmentButton(
                  label: _localizedLabel(context, p),
                  active: selected == p,
                  onTap: () => onChanged(p),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsetsDirectional.symmetric(vertical: AfiaSpacing.sm),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AfiaColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AfiaRadius.sm),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? AfiaColors.primary : AfiaColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
