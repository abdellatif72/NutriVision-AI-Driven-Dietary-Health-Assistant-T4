import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

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
        title: Text('Help', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.sm,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xxxl,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Support', style: AfiaTypography.cardTitle),
                const SizedBox(height: AfiaSpacing.sm),
                Text(
                  'We are here to help you get the most out of Afia.',
                  style: AfiaTypography.body.copyWith(
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.lg),
          _ContactCard(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Live Chat',
            subtitle: 'Average reply in under 2 hours',
            color: AfiaColors.primary,
            containerColor: AfiaColors.primaryContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat support coming soon')),
              );
            },
          ),
          const SizedBox(height: AfiaSpacing.md),
          _ContactCard(
            icon: Icons.mail_outline_rounded,
            title: 'Email Us',
            subtitle: 'support@afia.app',
            color: AfiaColors.blue,
            containerColor: AfiaColors.blueContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email support coming soon')),
              );
            },
          ),
          const SizedBox(height: AfiaSpacing.md),
          _ContactCard(
            icon: Icons.report_problem_outlined,
            title: 'Report a Problem',
            subtitle: 'Let us know what went wrong',
            color: AfiaColors.orange,
            containerColor: AfiaColors.orangeContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Problem reporting coming soon')),
              );
            },
          ),
          const SizedBox(height: AfiaSpacing.md),
          _ContactCard(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Help us improve Afia',
            color: AfiaColors.red,
            containerColor: AfiaColors.redContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback feature coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.containerColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color containerColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(AfiaSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: containerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AfiaTypography.cardTitle),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AfiaTypography.body),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AfiaColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
