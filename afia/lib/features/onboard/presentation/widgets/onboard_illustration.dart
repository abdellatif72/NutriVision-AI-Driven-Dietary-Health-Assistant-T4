import 'package:afia/core/theme/afia_colors.dart';
import 'package:flutter/material.dart';

/// Central character illustration surrounded by floating metric badges.
class OnboardIllustration extends StatelessWidget {
  const OnboardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Central character image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboard_illustration.png',
              fit: BoxFit.contain,
            ),
          ),

          // Floating metric badges
          const Positioned(
            top: 10,
            left: 10,
            child: _FloatingBadge(
              icon: Icons.restaurant_rounded,
              color: AfiaColors.orange,
              containerColor: AfiaColors.orangeContainer,
            ),
          ),
          const Positioned(
            top: 30,
            right: 10,
            child: _FloatingBadge(
              icon: Icons.water_drop_rounded,
              color: AfiaColors.blue,
              containerColor: AfiaColors.blueContainer,
            ),
          ),
          const Positioned(
            bottom: 70,
            left: 5,
            child: _FloatingBadge(
              icon: Icons.favorite_rounded,
              color: AfiaColors.red,
              containerColor: AfiaColors.redContainer,
            ),
          ),
          const Positioned(
            bottom: 50,
            right: 15,
            child: _FloatingBadge(
              icon: Icons.directions_run_rounded,
              color: AfiaColors.orange,
              containerColor: AfiaColors.orangeContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.icon,
    required this.color,
    required this.containerColor,
  });

  final IconData icon;
  final Color color;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: containerColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
