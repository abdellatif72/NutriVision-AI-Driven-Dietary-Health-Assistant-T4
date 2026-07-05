import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class WaterQuickTile extends StatelessWidget {
  const WaterQuickTile({super.key, required this.summary});

  final WaterSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pushNamed(context, RouteNames.water),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AfiaColors.blue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AfiaColors.blue.withValues(alpha: 0.30),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                color: AfiaColors.blue,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Water: ${summary.consumedLiters.toStringAsFixed(1)}L '
                      '/ ${summary.goalLiters.toStringAsFixed(1)}L',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: summary.percent,
                        minHeight: 4,
                        backgroundColor:
                            AfiaColors.blue.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AfiaColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AfiaColors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
