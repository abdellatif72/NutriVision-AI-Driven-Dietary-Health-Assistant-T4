import 'dart:math' as math;

import 'package:afia/core/theme/afia_colors.dart';
import 'package:flutter/material.dart';

class WaterProgressRing extends StatelessWidget {
  const WaterProgressRing({
    super.key,
    required this.consumedMl,
    required this.goalMl,
  });

  final int consumedMl;
  final int goalMl;

  double get _percent =>
      goalMl <= 0 ? 0 : (consumedMl / goalMl).clamp(0.0, 1.0);

  String _formatLiters(int ml) {
    final liters = ml / 1000;
    return '${liters.toStringAsFixed(1)}L';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: CustomPaint(
        painter: _RingPainter(percent: _percent),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatLiters(consumedMl),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AfiaColors.blue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'From ${_formatLiters(goalMl)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AfiaColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.percent});

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = AfiaColors.blue.withValues(alpha: 0.18);
    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = AfiaColors.blue;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.percent != percent;
}
