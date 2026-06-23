import 'package:flutter/material.dart';

/// Afia brand logo rendered from the actual logo image asset.
class OnboardLogo extends StatelessWidget {
  const OnboardLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/afia_logo.png',
        height: 60,
      ),
    );
  }
}
