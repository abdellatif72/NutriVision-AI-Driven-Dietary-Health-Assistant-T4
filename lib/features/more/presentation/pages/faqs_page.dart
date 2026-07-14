import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

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
        title: Text(l10n.faqs, style: AfiaTypography.screenTitle),
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
          _FaqTile(
            question: l10n.faq1Question,
            answer: l10n.faq1Answer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: l10n.faq2Question,
            answer: l10n.faq2Answer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: l10n.faq3Question,
            answer: l10n.faq3Answer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: l10n.faq4Question,
            answer: l10n.faq4Answer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: l10n.faq5Question,
            answer: l10n.faq5Answer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: l10n.faq6Question,
            answer: l10n.faq6Answer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: l10n.faq7Question,
            answer: l10n.faq7Answer,
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AfiaTypography.cardTitle,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AfiaColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AfiaSpacing.lg,
                0,
                AfiaSpacing.lg,
                AfiaSpacing.lg,
              ),
              child: Text(
                widget.answer,
                style: AfiaTypography.body.copyWith(
                  color: AfiaColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
