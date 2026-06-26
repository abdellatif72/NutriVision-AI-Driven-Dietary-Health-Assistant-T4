import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:flutter/material.dart';

class WeightTrendCard extends StatelessWidget {
  const WeightTrendCard({super.key, required this.trend});

  final WeightTrend trend;

  @override
  Widget build(BuildContext context) {
    final isLoss = trend.deltaKg < 0;
    final deltaColor = isLoss ? AfiaColors.green700 : AfiaColors.orange;
    final deltaText =
        '${isLoss ? '▼' : '▲'} ${trend.deltaKg.abs().toStringAsFixed(1)} kg';

    return Container(
      margin: EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        0,
        AfiaSpacing.pageMargin,
        AfiaSpacing.md,
      ),
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(AfiaRadius.md),
        border: Border.all(color: AfiaColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weight development',
                  style: AfiaTypography.cardTitle,
                ),
              ),
              Text(
                deltaText,
                style: AfiaTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: deltaColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AfiaSpacing.xs),
          Text(trend.caption, style: AfiaTypography.caption),
          const SizedBox(height: AfiaSpacing.sm),
          SizedBox(
            height: 36,
            child: CustomPaint(
              painter: _TrendPainter(points: trend.points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AfiaSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${trend.startKg.toStringAsFixed(1)} kg',
                style: AfiaTypography.caption,
              ),
              Text(
                '${trend.endKg.toStringAsFixed(1)} kg',
                style: AfiaTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.points});

  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AfiaColors.primary;
    final dot = Paint()..color = AfiaColors.primary;

    final stepX = size.width / (points.length - 1);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = stepX * i;
      final y = size.height - (points[i].clamp(0.0, 1.0)) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, stroke);
    final lastX = stepX * (points.length - 1);
    final lastY = size.height - (points.last.clamp(0.0, 1.0)) * size.height;
    canvas.drawCircle(Offset(lastX, lastY), 3, dot);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points;
}
