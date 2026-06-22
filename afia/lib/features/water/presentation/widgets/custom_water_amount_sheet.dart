import 'package:afia/core/theme/afia_colors.dart';
import 'package:flutter/material.dart';

const int _minMl = 50;
const int _maxMl = 3000;
const int _stepMl = 50;

Future<int?> showCustomWaterAmountSheet(
  BuildContext context, {
  int initialAmountMl = 350,
}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _CustomWaterAmountSheet(initialAmountMl: initialAmountMl),
  );
}

class _CustomWaterAmountSheet extends StatefulWidget {
  const _CustomWaterAmountSheet({required this.initialAmountMl});

  final int initialAmountMl;

  @override
  State<_CustomWaterAmountSheet> createState() =>
      _CustomWaterAmountSheetState();
}

class _CustomWaterAmountSheetState extends State<_CustomWaterAmountSheet> {
  late int _amountMl = widget.initialAmountMl.clamp(_minMl, _maxMl);

  void _increment() {
    setState(() {
      _amountMl = (_amountMl + _stepMl).clamp(_minMl, _maxMl);
    });
  }

  void _decrement() {
    setState(() {
      _amountMl = (_amountMl - _stepMl).clamp(_minMl, _maxMl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
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
                'Add custom quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AfiaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'In ml (e.g. 350)',
                style: TextStyle(
                  fontSize: 11,
                  color: AfiaColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _AmountDisplay(amountMl: _amountMl)),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 56,
                    child: Column(
                      children: [
                        Expanded(
                          child: _StepButton(
                            symbol: '+',
                            highlighted: true,
                            onTap: _increment,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _StepButton(
                            symbol: '−',
                            onTap: _decrement,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SheetButton(
                      label: 'Add',
                      filled: true,
                      onTap: () => Navigator.pop(context, _amountMl),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SheetButton(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({required this.amountMl});

  final int amountMl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AfiaColors.scaffoldBackground,
        border: Border.all(color: AfiaColors.divider),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text(
            'Quantity',
            style: TextStyle(
              fontSize: 11,
              color: AfiaColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$amountMl',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AfiaColors.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'ml',
            style: TextStyle(
              fontSize: 11,
              color: AfiaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.symbol,
    required this.onTap,
    this.highlighted = false,
  });

  final String symbol;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: highlighted
              ? AfiaColors.primary.withValues(alpha: 0.12)
              : AfiaColors.scaffoldBackground,
          border: Border.all(
            color: highlighted ? AfiaColors.primary : AfiaColors.divider,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: highlighted ? AfiaColors.primary : AfiaColors.textPrimary,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AfiaColors.green700 : AfiaColors.surface,
          border: Border.all(
            color: filled ? AfiaColors.green700 : AfiaColors.divider,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: filled ? Colors.white : AfiaColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
