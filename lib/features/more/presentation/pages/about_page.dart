import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('About Afia', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.xl,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xxxl,
        ),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AfiaColors.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    color: AfiaColors.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AfiaSpacing.md),
                Text(
                  'Afia',
                  style: AfiaTypography.screenTitle.copyWith(
                    fontSize: 24,
                    color: AfiaColors.primary,
                  ),
                ),
                const SizedBox(height: AfiaSpacing.sm),
                Text(
                  'Version 1.0.0',
                  style: AfiaTypography.body.copyWith(
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.xxxl),
          Container(
            padding: const EdgeInsets.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your AI-Driven Dietary Health Assistant',
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: AfiaSpacing.md),
                Text(
                  'Afia helps you track your daily nutrition, water intake, '
                  'and health metrics. Powered by AI, it provides personalized '
                  'meal recommendations and insights to support your wellness journey.',
                  style: AfiaTypography.body.copyWith(
                    color: AfiaColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Team', style: AfiaTypography.cardTitle),
                const SizedBox(height: AfiaSpacing.md),
                _teamMember('Sara', 'Design & Development'),
                const SizedBox(height: AfiaSpacing.sm),
                _teamMember('Ahmed', 'Backend & AI'),
                const SizedBox(height: AfiaSpacing.sm),
                _teamMember('Layla', 'Research & Content'),
                const SizedBox(height: AfiaSpacing.sm),
                _teamMember('Khalid', 'Testing & QA'),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _linkRow('Terms of Service', () {}),
                const Divider(height: 1, color: AfiaColors.divider),
                _linkRow('Privacy Policy', () {}),
                const Divider(height: 1, color: AfiaColors.divider),
                _linkRow('Open Source Licenses', () {}),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.xxxl),
          Center(
            child: Text(
              'Made with ❤️ for better health',
              style: AfiaTypography.body.copyWith(color: AfiaColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamMember(String name, String role) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AfiaColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            name[0],
            style: AfiaTypography.cardTitle.copyWith(
              color: AfiaColors.primary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: AfiaSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AfiaTypography.cardTitle),
            Text(
              role,
              style: AfiaTypography.body.copyWith(
                color: AfiaColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _linkRow(String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: AfiaTypography.cardTitle),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AfiaColors.textMuted,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
