import 'package:flutter/material.dart';
import '../theme/afia_colors.dart';
import '../theme/afia_spacing.dart';
import '../theme/afia_typography.dart';

/// The smaller two-up cards at the bottom of the Statistics screen
/// (Exercise, BPM, Weight, Water): icon chip + label up top, big value
/// below, with room for an optional mini visual (sparkline, bars).
class AfiaMiniMetricCard extends StatelessWidget {
  const AfiaMiniMetricCard({
    super.key,
    required this.kind,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.visual,
  });

  final AfiaMetricKind kind;
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  /// Optional small chart/sparkline rendered above the value, e.g. a
  /// [AfiaSparkline] or a row of mini bars.
  final Widget? visual;

  @override
  Widget build(BuildContext context) {
    final (accent, container) = AfiaColors.accentFor(kind);

    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: container, shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: accent),
              ),
              const SizedBox(width: AfiaSpacing.sm),
              Text(label, style: AfiaTypography.label),
            ],
          ),
          if (visual != null) ...[
            const SizedBox(height: AfiaSpacing.md),
            SizedBox(height: 36, child: visual),
          ],
          const SizedBox(height: AfiaSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AfiaTypography.statValueCompact),
              const SizedBox(width: 4),
              Text(unit, style: AfiaTypography.unit),
            ],
          ),
        ],
      ),
    );
  }
}

/// A tiny line sparkline (used inside the BPM card). Pass values
/// already normalized 0-1, or raw values + [minValue]/[maxValue].
class AfiaSparkline extends StatelessWidget {
  const AfiaSparkline({
    super.key,
    required this.values,
    this.color = AfiaColors.red,
  });

  final List<double> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(values: values, color: color),
      child: const SizedBox.expand(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.color});
  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min) == 0 ? 1 : (max - min);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final normalized = (values[i] - min) / range;
      final y = size.height * (1 - normalized);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
