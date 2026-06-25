import 'package:flutter/material.dart';

/// Afia brand logo rendered from the actual logo image asset.
class OnboardLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const OnboardLogo({
    super.key,
    this.width,
    this.height = 60.0, // Default fallback height
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/afia_logo.png',
        width: width,
        height: height,
        fit: BoxFit.contain, 
      ),
    );
  }
}
