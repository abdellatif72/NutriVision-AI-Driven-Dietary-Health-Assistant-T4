import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';

class ProgressSettingsPage extends StatelessWidget {
  const ProgressSettingsPage({super.key});

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
        title: Text('Goals & Targets', style: AfiaTypography.screenTitle),
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
          const SectionTitle('Current Status'),
          const SizedBox(height: AfiaSpacing.md),
          _MetricCard(
            icon: Icons.monitor_weight_outlined,
            title: 'Current Weight',
            value: '62.4 kg',
            accent: AfiaColors.primary,
            container: AfiaColors.primaryContainer,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _MetricCard(
            icon: Icons.track_changes_rounded,
            title: 'Target Weight',
            value: '58.0 kg',
            accent: AfiaColors.orange,
            container: AfiaColors.orangeContainer,
          ),
          const SizedBox(height: AfiaSpacing.xl),
          const SectionTitle('Targets'),
          const SizedBox(height: AfiaSpacing.md),
          _TargetRow(
            label: 'Daily Calories',
            value: '2,000 kcal',
            onEdit: () {},
          ),
          const SizedBox(height: AfiaSpacing.sm),
          _TargetRow(label: 'Daily Water', value: '2.5 L', onEdit: () {}),
          const SizedBox(height: AfiaSpacing.sm),
          _TargetRow(label: 'Daily Steps', value: '10,000', onEdit: () {}),
          const SizedBox(height: AfiaSpacing.xl),
          const SectionTitle('Milestones'),
          const SizedBox(height: AfiaSpacing.md),
          _MilestoneCard(
            title: '14-day streak',
            subtitle: 'Logged meals for 14 consecutive days',
            achieved: true,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _MilestoneCard(
            title: 'First kg lost',
            subtitle: 'Reach 61.4 kg to unlock',
            achieved: false,
          ),
          const SizedBox(height: AfiaSpacing.md),
          _MilestoneCard(
            title: 'Perfect week',
            subtitle: 'Meet all targets for 7 days',
            achieved: false,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
    required this.container,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color accent;
  final Color container;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: container, shape: BoxShape.circle),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: AfiaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AfiaTypography.body),
                const SizedBox(height: 4),
                Text(value, style: AfiaTypography.cardTitle),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded, color: AfiaColors.textMuted, size: 20),
        ],
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  const _TargetRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AfiaTypography.body),
                const SizedBox(height: 4),
                Text(value, style: AfiaTypography.cardTitle),
              ],
            ),
          ),
          TextButton(onPressed: onEdit, child: const Text('Edit')),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.title,
    required this.subtitle,
    required this.achieved,
  });

  final String title;
  final String subtitle;
  final bool achieved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: achieved
                  ? AfiaColors.primaryContainer
                  : AfiaColors.scaffoldBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achieved
                  ? Icons.emoji_events_rounded
                  : Icons.lock_outline_rounded,
              color: achieved ? AfiaColors.primary : AfiaColors.textMuted,
            ),
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
        ],
      ),
    );
  }
}
