import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:flutter/material.dart';

class PeriodSegmentedControl extends StatelessWidget {
  const PeriodSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ProgressPeriod selected;
  final ValueChanged<ProgressPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        0,
        AfiaSpacing.pageMargin,
        AfiaSpacing.md,
      ),
      padding: const EdgeInsets.all(AfiaSpacing.xs),
      decoration: BoxDecoration(
        color: AfiaColors.divider,
        borderRadius: BorderRadius.circular(AfiaRadius.sm),
      ),
      child: Row(
        children: ProgressPeriod.values
            .map(
              (p) => Expanded(
                child: _SegmentButton(
                  label: p.label,
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
        padding: const EdgeInsets.symmetric(vertical: AfiaSpacing.sm),
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
