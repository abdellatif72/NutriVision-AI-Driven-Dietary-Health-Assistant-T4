import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

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
        title: Text('FAQs', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.sm,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xxxl,
        ),
        children: const [
          _FaqTile(
            question: 'How do I change my calorie goal?',
            answer:
                'Go to More > Diet Preferences, then adjust your calorie target and macro split.',
          ),
          SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: 'Can I track water reminders?',
            answer:
                'Yes. Go to More > Notifications and enable water reminders. You can set the interval between 1-4 hours.',
          ),
          SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: 'How do I reset my password?',
            answer:
                'Go to More > Change Password. Enter your current password, then your new password twice.',
          ),
          SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: 'How is my daily calorie target calculated?',
            answer:
                'Your target is based on your age, gender, height, weight, activity level, and selected goal (lose/maintain/gain).',
          ),
          SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: 'Can I use Afia offline?',
            answer:
                'Basic logging features work offline. Syncing across devices requires an internet connection.',
          ),
          SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: 'How do I change my language preference?',
            answer:
                'Go to More > Settings > Language to switch between العربية and English.',
          ),
          SizedBox(height: AfiaSpacing.md),
          _FaqTile(
            question: 'Is my data secure?',
            answer:
                'Yes. Your health data is encrypted and stored securely. We do not share your personal information with third parties.',
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
              padding: const EdgeInsets.all(AfiaSpacing.lg),
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
              padding: const EdgeInsets.fromLTRB(
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
