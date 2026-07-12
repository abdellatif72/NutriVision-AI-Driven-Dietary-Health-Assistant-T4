import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class AfiaErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onRetry;

  const AfiaErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.buttonText = 'Try again',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.xxl,
        vertical: AfiaSpacing.xxxl,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AfiaColors.redContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AfiaColors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: AfiaSpacing.xl),
            Text(
              title,
              style: AfiaTypography.cardTitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AfiaSpacing.sm),
            Text(
              message,
              style: AfiaTypography.body.copyWith(
                color: AfiaColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AfiaSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AfiaColors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AfiaSpacing.lg,
                    vertical: AfiaSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
