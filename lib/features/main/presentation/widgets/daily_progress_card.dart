import 'dart:math' as math;
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({
    super.key,
    required this.percent,
    required this.description,
  });

  final double percent;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AfiaColors.green50,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AfiaColors.green900.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Progress',
                  style: AfiaTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AfiaColors.green900.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${(percent * 100).round()}',
                      style: AfiaTypography.statValue.copyWith(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: AfiaColors.green900,
                      ),
                    ),
                    Text(
                      '%',
                      style: AfiaTypography.statValueCompact.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AfiaColors.green900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: AfiaTypography.body.copyWith(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: AfiaColors.green900.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 88,
            height: 88,
            child: CustomPaint(
              painter: _ProgressRingPainter(
                percent: percent,
                trackColor: AfiaColors.green100,
                progressColor: AfiaColors.green500,
                strokeWidth: 8.5,
              ),
              child: const Center(
                child: Icon(
                  Icons.eco,
                  color: AfiaColors.green500,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.percent,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double percent;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - strokeWidth / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
