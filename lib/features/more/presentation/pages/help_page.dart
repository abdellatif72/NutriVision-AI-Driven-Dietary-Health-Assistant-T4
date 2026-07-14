import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.help, style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.sm,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xxxl,
        ),
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.contactSupport, style: AfiaTypography.cardTitle),
                const SizedBox(height: AfiaSpacing.sm),
                Text(
                  l10n.helpSubtitle,
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
            title: l10n.liveChat,
            subtitle: l10n.liveChatSubtitle,
            color: AfiaColors.primary,
            containerColor: AfiaColors.primaryContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.chatSupportComingSoon)),
              );
            },
          ),
          const SizedBox(height: AfiaSpacing.md),
          _ContactCard(
            icon: Icons.mail_outline_rounded,
            title: l10n.emailUs,
            subtitle: l10n.emailUsSubtitle,
            color: AfiaColors.blue,
            containerColor: AfiaColors.blueContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.emailSupportComingSoon)),
              );
            },
          ),
          const SizedBox(height: AfiaSpacing.md),
          _ContactCard(
            icon: Icons.report_problem_outlined,
            title: l10n.reportProblem,
            subtitle: l10n.reportProblemSubtitle,
            color: AfiaColors.orange,
            containerColor: AfiaColors.orangeContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.problemReportingComingSoon)),
              );
            },
          ),
          const SizedBox(height: AfiaSpacing.md),
          _ContactCard(
            icon: Icons.feedback_outlined,
            title: l10n.sendFeedback,
            subtitle: l10n.sendFeedbackSubtitle,
            color: AfiaColors.red,
            containerColor: AfiaColors.redContainer,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.feedbackFeatureComingSoon)),
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
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
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
              Icon(
                isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                color: AfiaColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
