import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
        title: Text(l10n.aboutAfia, style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
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
                  l10n.afia,
                  style: AfiaTypography.screenTitle.copyWith(
                    fontSize: 24,
                    color: AfiaColors.primary,
                  ),
                ),
                const SizedBox(height: AfiaSpacing.sm),
                Text(
                  l10n.version('1.0.0'),
                  style: AfiaTypography.body.copyWith(
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.xxxl),
          Container(
            padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'مساعدك الصحي الموجه بالذكاء الاصطناعي' : 'Your AI-Driven Dietary Health Assistant',
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: AfiaSpacing.md),
                Text(
                  l10n.afiaDescription,
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
            padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.projectTeam, style: AfiaTypography.cardTitle),
                const SizedBox(height: AfiaSpacing.md),
                _teamMember(l10n.teamMemberAhmed, l10n.teamMemberAhmedRole),
                const SizedBox(height: AfiaSpacing.sm),
                _teamMember(l10n.teamMemberMarawan, l10n.teamMemberMarawanRole),
                const SizedBox(height: AfiaSpacing.sm),
                _teamMember(l10n.teamMemberMario, l10n.teamMemberMarioRole),
                const SizedBox(height: AfiaSpacing.sm),
                _teamMember(l10n.teamMemberYusuf, l10n.teamMemberYusufRole),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.lg),
          Container(
            padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _linkRow(context, l10n.termsOfService, () {}),
                const Divider(height: 1, color: AfiaColors.divider),
                _linkRow(context, l10n.privacyPolicy, () {}),
                const Divider(height: 1, color: AfiaColors.divider),
                _linkRow(context, l10n.openSourceLicenses, () {}),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.xxxl),
          Center(
            child: Text(
              l10n.madeWithHeart,
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
            name.isNotEmpty ? name[0] : '',
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

  Widget _linkRow(BuildContext context, String title, VoidCallback onTap) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ListTile(
      onTap: onTap,
      title: Text(title, style: AfiaTypography.cardTitle),
      trailing: Icon(
        isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        color: AfiaColors.textMuted,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
