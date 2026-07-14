import 'dart:math' as math;

import 'package:afia/app/localization/l10n.dart';

import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:afia/features/water/presentation/widgets/custom_water_amount_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterRecordingPage extends StatelessWidget {
  const WaterRecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<WaterRecordingCubit>()..loadWaterData(),
      child: const _WaterRecordingView(),
    );
  }
}

class _WaterRecordingView extends StatefulWidget {
  const _WaterRecordingView();

  @override
  State<_WaterRecordingView> createState() => _WaterRecordingViewState();
}

class _WaterRecordingViewState extends State<_WaterRecordingView> {
  void _onAmountTap(BuildContext context, int amountMl) {
    final cubit = context.read<WaterRecordingCubit>();
    if (amountMl == 250) {
      cubit.addPreset(WaterPreset.cup);
    } else if (amountMl == 500) {
      cubit.addPreset(WaterPreset.pint);
    } else if (amountMl == 750) {
      // Custom amount
      showCustomWaterAmountSheet(context).then((amount) {
        if (amount != null) {
          cubit.addCustomAmount(amount);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAF7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AfiaColors.textPrimary,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.waterTracker,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AfiaColors.textPrimary,
          ),
        ),
        actions: const [],
      ),
      body: BlocBuilder<WaterRecordingCubit, WaterRecordingState>(
        builder: (context, state) {
          final percent = state.progress;
          final consumedLiters = state.consumedMl / 1000;
          final goalLiters = state.goalMl / 1000;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            children: [
              const SizedBox(height: 6),
              Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: CustomPaint(
                    painter: _WaterRingPainter(percent: percent),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 30,
                          color: AfiaColors.blue,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isAr
                              ? '${consumedLiters.toStringAsFixed(1)} لتر'
                              : '${consumedLiters.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontSize: 38,
                            height: 1,
                            fontWeight: FontWeight.w800,
                            color: AfiaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isAr
                              ? 'من ${goalLiters.toStringAsFixed(1)} لتر'
                              : 'of ${goalLiters.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AfiaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  isAr
                      ? '${(percent * 100).round()}% من الهدف اليومي'
                      : '${(percent * 100).round()}% of daily goal',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _WaterAmountButton(
                      label: isAr ? '+٢٥٠ مل' : '+250 ml',
                      onTap: () => _onAmountTap(context, 250),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _WaterAmountButton(
                      label: isAr ? '+٥٠٠ مل' : '+500 ml',
                      onTap: () => _onAmountTap(context, 500),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _WaterAmountButton(
                      label: isAr ? 'مخصص' : 'Custom',
                      onTap: () => _onAmountTap(context, 750),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                isAr ? 'سجل اليوم' : "Today's Log",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AfiaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AfiaColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE9ECE7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < state.entries.length; i++) ...[
                      _WaterLogRow(
                        entry: state.entries[i],
                        isAr: isAr,
                        onAdd: () {
                          final entry = state.entries[i];
                          if (entry.preset == WaterPreset.cup) {
                            context.read<WaterRecordingCubit>().addPreset(WaterPreset.cup);
                          } else if (entry.preset == WaterPreset.pint) {
                            context.read<WaterRecordingCubit>().addPreset(WaterPreset.pint);
                          } else {
                            context.read<WaterRecordingCubit>().addCustomAmount(entry.amountMl);
                          }
                        },
                        onDelete: () => context
                            .read<WaterRecordingCubit>()
                            .deleteEntry(state.entries[i].id),
                      ),
                      if (i != state.entries.length - 1)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF0F2EE),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          );
        },
      ),
    );
  }
}

class _WaterRingPainter extends CustomPainter {
  _WaterRingPainter({required this.percent});

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 10;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE1EFFE);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = AfiaColors.blue;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WaterRingPainter oldDelegate) =>
      oldDelegate.percent != percent;
}

class _WaterAmountButton extends StatelessWidget {
  const _WaterAmountButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEAF4FF),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD8E9FF)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AfiaColors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class _WaterLogRow extends StatelessWidget {
  const _WaterLogRow({
    required this.entry,
    required this.isAr,
    required this.onAdd,
    required this.onDelete,
  });

  final WaterEntry entry;
  final bool isAr;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  String _formatTime(DateTime time) {
    final hour12 = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12
        ? (isAr ? 'م' : 'PM')
        : (isAr ? 'ص' : 'AM');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minutes $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(
              _formatTime(entry.timestamp),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AfiaColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              isAr ? '${entry.amountMl} مل' : '${entry.amountMl} ml',
              textAlign: isAr ? TextAlign.left : TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AfiaColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Material(
            color: AfiaColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onAdd,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 26,
                height: 26,
                child: Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AfiaColors.orange,
              size: 20,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

