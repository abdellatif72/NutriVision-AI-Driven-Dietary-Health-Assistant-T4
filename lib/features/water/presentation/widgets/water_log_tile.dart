import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:flutter/material.dart';

class WaterLogTile extends StatelessWidget {
  const WaterLogTile({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  final WaterEntry entry;
  final VoidCallback onDelete;

  String _formatTime(DateTime t) {
    final hour12 = t.hour == 0
        ? 12
        : (t.hour > 12 ? t.hour - 12 : t.hour);
    final period = t.hour >= 12 ? 'PM' : 'AM';
    final minutes = t.minute.toString().padLeft(2, '0');
    return '$hour12:$minutes $period';
  }

  String get _amountLabel {
    switch (entry.preset) {
      case WaterPreset.cup:
        return '${entry.amountMl} ml · cup';
      case WaterPreset.pint:
        return '${entry.amountMl} ml · half a liter';
      case WaterPreset.custom:
        return '${entry.amountMl} ml · custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AfiaColors.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              _formatTime(entry.timestamp),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AfiaColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _amountLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AfiaColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
              color: AfiaColors.textSecondary,
            ),
          ),
          IconButton(
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: AfiaColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
