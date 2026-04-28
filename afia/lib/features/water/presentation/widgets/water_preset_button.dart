import 'package:afia/app/theme/app_colors.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:flutter/material.dart';

class WaterPresetButton extends StatelessWidget {
  const WaterPresetButton({
    super.key,
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final WaterPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    switch (preset) {
      case WaterPreset.cup:
        icon = Icons.water_drop_outlined;
        break;
      case WaterPreset.pint:
        icon = Icons.local_drink_outlined;
        break;
      case WaterPreset.custom:
        icon = Icons.edit_outlined;
        break;
    }

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.hydration.withValues(alpha: 0.10)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.hydration : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.hydration, size: 22),
              const SizedBox(height: 6),
              Text(
                preset.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                preset.sublabel,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
