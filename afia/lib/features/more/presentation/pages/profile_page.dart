import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        title: Text('Profile', style: AfiaTypography.screenTitle),
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
          _HeroSummaryCard(
            title: 'Sara Khan',
            subtitle: 'Healthy routine • 4 week streak',
            accent: AfiaColors.primary,
            child: Row(
              children: const [
                _SmallStat(label: 'Weight', value: '62.4 kg'),
                SizedBox(width: AfiaSpacing.md),
                _SmallStat(label: 'Height', value: '165 cm'),
                SizedBox(width: AfiaSpacing.md),
                _SmallStat(label: 'BMI', value: '22.9'),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.xl),
          ActionGroupCard(
            children: [
              SettingsTile(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                trailing: 'Sara Khan',
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.editProfile),
              ),
              SettingsTile(
                icon: Icons.restaurant_outlined,
                title: 'Diet Preferences',
                trailing: 'Balanced',
              ),
              SettingsTile(
                icon: Icons.security_outlined,
                title: 'Security',
                trailing: 'Managed',
              ),
            ],
          ),
          const SizedBox(height: AfiaSpacing.xl),
          const SectionTitle('Today at a glance'),
          const SizedBox(height: AfiaSpacing.md),
          Row(
            children: const [
              Expanded(
                child: _MiniInfoCard(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Calories',
                  value: '1,420',
                  accent: AfiaColors.orange,
                  container: AfiaColors.orangeContainer,
                ),
              ),
              SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: _MiniInfoCard(
                  icon: Icons.directions_walk_rounded,
                  label: 'Steps',
                  value: '5,480',
                  accent: AfiaColors.primary,
                  container: AfiaColors.primaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSummaryCard extends StatelessWidget {
  const _HeroSummaryCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'SK',
                  style: AfiaTypography.cardTitle.copyWith(color: accent),
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
          const SizedBox(height: AfiaSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AfiaSpacing.md),
        decoration: BoxDecoration(
          color: AfiaColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AfiaTypography.label),
            const SizedBox(height: 4),
            Text(value, style: AfiaTypography.cardTitle),
          ],
        ),
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  const _MiniInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.container,
  });

  final IconData icon;
  final String label;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: container, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: AfiaSpacing.md),
          Text(label, style: AfiaTypography.label),
          const SizedBox(height: 4),
          Text(value, style: AfiaTypography.cardTitle),
        ],
      ),
    );
  }
}
