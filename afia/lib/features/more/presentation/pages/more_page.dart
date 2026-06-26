import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text('More', style: AfiaTypography.screenTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.sm,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xxxl,
        ),
        children: [
          _ProfileCard(
            onTap: () => Navigator.pushNamed(context, RouteNames.profile),
          ),
          const SizedBox(height: AfiaSpacing.xl),
          _MoreSection(
            children: [
              _MoreTile(
                icon: Icons.flag_outlined,
                title: 'Goals',
                subtitle: 'Edit your goals',
                onTap: () => Navigator.pushNamed(context, RouteNames.goals),
              ),
              _MoreTile(
                icon: Icons.bar_chart_outlined,
                title: 'Progress',
                subtitle: 'See your history',
                onTap: () => Navigator.pushNamed(context, RouteNames.progress),
              ),
              _MoreTile(
                icon: Icons.notifications_none_rounded,
                title: 'Reminders',
                subtitle: 'Set your reminders',
                onTap: () => Navigator.pushNamed(context, RouteNames.reminders),
              ),
              _MoreTile(
                icon: Icons.link_rounded,
                title: 'Connected Apps',
                subtitle: 'Manage your integrations',
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.connectedApps,
                ),
              ),
              _MoreTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'App preferences',
                onTap: () => Navigator.pushNamed(context, RouteNames.settings),
              ),
              _MoreTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help and FAQs',
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.helpSupport,
                ),
              ),
            ],
          ),
          const SizedBox(height: AfiaSpacing.lg),
          TextButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
            style: TextButton.styleFrom(
              foregroundColor: AfiaColors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.sm,
                vertical: AfiaSpacing.md,
              ),
              textStyle: AfiaTypography.cardTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text('This will return you to the authentication screen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.auth,
                  (_) => false,
                );
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.onTap});

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
              const CircleAvatar(
                radius: 26,
                backgroundColor: AfiaColors.primaryContainer,
                child: Icon(
                  Icons.person_rounded,
                  color: AfiaColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sara Khan', style: AfiaTypography.cardTitle),
                    const SizedBox(height: 4),
                    Text('View your profile', style: AfiaTypography.body),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AfiaColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreSection extends StatelessWidget {
  const _MoreSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i != 0)
              const Divider(height: 1, thickness: 1, color: AfiaColors.divider),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: 2,
      ),
      leading: Icon(icon, color: AfiaColors.textSecondary, size: 22),
      title: Text(title, style: AfiaTypography.cardTitle),
      subtitle: Text(subtitle, style: AfiaTypography.body),
      trailing: const Icon(Icons.chevron_right_rounded, color: AfiaColors.textMuted),
    );
  }
}

class MoreSectionPage extends StatelessWidget {
  const MoreSectionPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final body = switch (title) {
      'Profile' => const _ProfileSection(),
      'Goals' => const _GoalsSection(),
      'Progress' => const _ProgressSection(),
      'Reminders' => const _RemindersSection(),
      'Connected Apps' => const _ConnectedAppsSection(),
      'Help & Support' => const _HelpSupportSection(),
      _ => _FallbackSection(title: title),
    };

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(title, style: AfiaTypography.screenTitle),
      ),
      body: body,
    );
  }
}

class _FallbackSection extends StatelessWidget {
  const _FallbackSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AfiaSpacing.xxl),
        child: Text(
          '$title screen coming soon.',
          textAlign: TextAlign.center,
          style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
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
              _SmallStat(label: 'Weight', value: '62.4'),
              SizedBox(width: AfiaSpacing.md),
              _SmallStat(label: 'Meals', value: '16'),
              SizedBox(width: AfiaSpacing.md),
              _SmallStat(label: 'Water', value: '2.1 L'),
            ],
          ),
        ),
        const SizedBox(height: AfiaSpacing.xl),
        _ActionGroupCard(
          children: [
            _SettingsTile(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              trailing: 'Sara Khan',
            ),
            _SettingsTile(
              icon: Icons.restaurant_outlined,
              title: 'Diet Preferences',
              trailing: 'Balanced',
            ),
            _SettingsTile(
              icon: Icons.security_outlined,
              title: 'Security',
              trailing: 'Managed',
            ),
          ],
        ),
        const SizedBox(height: AfiaSpacing.xl),
        const _SectionTitle('Today at a glance'),
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
    );
  }
}

class _GoalsSection extends StatelessWidget {
  const _GoalsSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        AfiaSpacing.sm,
        AfiaSpacing.pageMargin,
        AfiaSpacing.xxxl,
      ),
      children: const [
        _SectionTitle('Daily targets'),
        SizedBox(height: AfiaSpacing.md),
        _GoalCard(
          icon: Icons.local_fire_department_outlined,
          title: 'Calories',
          value: '1,850 / 2,000 kcal',
          progress: 0.925,
          accent: AfiaColors.orange,
          container: AfiaColors.orangeContainer,
        ),
        SizedBox(height: AfiaSpacing.md),
        _GoalCard(
          icon: Icons.water_drop_outlined,
          title: 'Water',
          value: '2.1 / 2.5 L',
          progress: 0.84,
          accent: AfiaColors.blue,
          container: AfiaColors.blueContainer,
        ),
        SizedBox(height: AfiaSpacing.md),
        _GoalCard(
          icon: Icons.directions_walk_rounded,
          title: 'Steps',
          value: '5,480 / 10,000',
          progress: 0.548,
          accent: AfiaColors.primary,
          container: AfiaColors.primaryContainer,
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        AfiaSpacing.sm,
        AfiaSpacing.pageMargin,
        AfiaSpacing.xxxl,
      ),
      children: [
        const _SectionTitle('History'),
        const SizedBox(height: AfiaSpacing.md),
        _ActionGroupCard(
          children: const [
            _ProgressRow(
              label: 'This week',
              detail: 'Average intake 1,730 kcal',
              progress: 0.79,
            ),
            _ProgressRow(
              label: 'Last week',
              detail: '+8% hydration',
              progress: 0.66,
            ),
            _ProgressRow(
              label: 'Weight trend',
              detail: '-0.6 kg in 30 days',
              progress: 0.42,
            ),
          ],
        ),
        const SizedBox(height: AfiaSpacing.xl),
        const _SectionTitle('Milestones'),
        const SizedBox(height: AfiaSpacing.md),
        const _TimelineCard(
          title: 'Completed 4 healthy days in a row',
          subtitle: 'Best streak since onboarding',
        ),
      ],
    );
  }
}

class _RemindersSection extends StatefulWidget {
  const _RemindersSection();

  @override
  State<_RemindersSection> createState() => _RemindersSectionState();
}

class _RemindersSectionState extends State<_RemindersSection> {
  bool water = true;
  bool meals = true;
  bool weighIn = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        AfiaSpacing.sm,
        AfiaSpacing.pageMargin,
        AfiaSpacing.xxxl,
      ),
      children: [
        const _SectionTitle('Smart reminders'),
        const SizedBox(height: AfiaSpacing.md),
        _ActionGroupCard(
          children: [
            SwitchListTile.adaptive(
              value: water,
              onChanged: (value) => setState(() => water = value),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.lg,
              ),
              title: Text('Water reminder', style: AfiaTypography.cardTitle),
              subtitle: Text('Every 2 hours', style: AfiaTypography.body),
            ),
            const Divider(height: 1, thickness: 1, color: AfiaColors.divider),
            SwitchListTile.adaptive(
              value: meals,
              onChanged: (value) => setState(() => meals = value),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.lg,
              ),
              title: Text('Meal logging', style: AfiaTypography.cardTitle),
              subtitle: Text('Breakfast, lunch and dinner', style: AfiaTypography.body),
            ),
            const Divider(height: 1, thickness: 1, color: AfiaColors.divider),
            SwitchListTile.adaptive(
              value: weighIn,
              onChanged: (value) => setState(() => weighIn = value),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.lg,
              ),
              title: Text('Weekly weigh-in', style: AfiaTypography.cardTitle),
              subtitle: Text('Friday morning', style: AfiaTypography.body),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConnectedAppsSection extends StatelessWidget {
  const _ConnectedAppsSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        AfiaSpacing.sm,
        AfiaSpacing.pageMargin,
        AfiaSpacing.xxxl,
      ),
      children: const [
        _SectionTitle('Integrations'),
        SizedBox(height: AfiaSpacing.md),
        _IntegrationCard(
          icon: Icons.watch_outlined,
          title: 'Google Fit',
          subtitle: 'Steps and activity',
          status: 'Connected',
          connected: true,
        ),
        SizedBox(height: AfiaSpacing.md),
        _IntegrationCard(
          icon: Icons.favorite_border,
          title: 'Apple Health',
          subtitle: 'Health metrics sync',
          status: 'Not connected',
          connected: false,
        ),
        SizedBox(height: AfiaSpacing.md),
        _IntegrationCard(
          icon: Icons.fitness_center_outlined,
          title: 'Samsung Health',
          subtitle: 'Workout and body data',
          status: 'Not connected',
          connected: false,
        ),
      ],
    );
  }
}

class _HelpSupportSection extends StatelessWidget {
  const _HelpSupportSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        AfiaSpacing.sm,
        AfiaSpacing.pageMargin,
        AfiaSpacing.xxxl,
      ),
      children: const [
        _SectionTitle('Support'),
        SizedBox(height: AfiaSpacing.md),
        _SupportCard(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Chat with support',
          subtitle: 'Average reply in under 2 hours',
        ),
        SizedBox(height: AfiaSpacing.md),
        _SupportCard(
          icon: Icons.mail_outline_rounded,
          title: 'Email us',
          subtitle: 'support@afia.app',
        ),
        SizedBox(height: AfiaSpacing.xl),
        _SectionTitle('FAQs'),
        SizedBox(height: AfiaSpacing.md),
        _FaqCard(
          question: 'How do I change my calorie goal?',
          answer: 'Open Goals, then adjust the daily target card.',
        ),
        SizedBox(height: AfiaSpacing.md),
        _FaqCard(
          question: 'Can I track water reminders?',
          answer: 'Yes. You can enable reminders from the Reminders screen.',
        ),
      ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AfiaTypography.label.copyWith(color: AfiaColors.textPrimary));
  }
}

class _ActionGroupCard extends StatelessWidget {
  const _ActionGroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i != 0)
              const Divider(height: 1, thickness: 1, color: AfiaColors.divider),
            children[i],
          ],
        ],
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

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
    required this.accent,
    required this.container,
  });

  final IconData icon;
  final String title;
  final String value;
  final double progress;
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: container, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(width: AfiaSpacing.sm),
              Text(title, style: AfiaTypography.cardTitle),
              const Spacer(),
              Text(value, style: AfiaTypography.body),
            ],
          ),
          const SizedBox(height: AfiaSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AfiaColors.trackInactive,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.detail,
    required this.progress,
  });

  final String label;
  final String detail;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AfiaTypography.cardTitle),
              const Spacer(),
              Text(detail, style: AfiaTypography.body),
            ],
          ),
          const SizedBox(height: AfiaSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AfiaColors.trackInactive,
              valueColor: const AlwaysStoppedAnimation<Color>(AfiaColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

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
            decoration: const BoxDecoration(
              color: AfiaColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_outlined, color: AfiaColors.primary),
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

class _IntegrationCard extends StatelessWidget {
  const _IntegrationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.connected,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final bool connected;

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
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AfiaColors.scaffoldBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AfiaColors.textSecondary),
          ),
          const SizedBox(width: AfiaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AfiaTypography.cardTitle),
                const SizedBox(height: 4),
                Text(subtitle, style: AfiaTypography.body),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: AfiaTypography.caption.copyWith(
                    color: connected ? AfiaColors.primary : AfiaColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AfiaSpacing.sm),
          FilledButton.tonal(
            onPressed: () {},
            child: Text(connected ? 'Manage' : 'Connect'),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

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
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AfiaColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AfiaColors.primary),
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
          const Icon(Icons.chevron_right_rounded, color: AfiaColors.textMuted),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.question, required this.answer});

  final String question;
  final String answer;

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
          Text(question, style: AfiaTypography.cardTitle),
          const SizedBox(height: AfiaSpacing.sm),
          Text(answer, style: AfiaTypography.body),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        title: Text('Settings', style: AfiaTypography.screenTitle),
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
          _SettingsGroup(
            title: 'Preferences',
            children: [
              _SettingsTile(
                icon: Icons.straighten_rounded,
                title: 'Units',
                trailing: 'Metric (kg, cm)',
              ),
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                trailing: 'Light',
              ),
              _SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                trailing: 'On',
              ),
            ],
          ),
          SizedBox(height: AfiaSpacing.xl),
          _SettingsGroup(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Personal Information',
              ),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
              ),
            ],
          ),
          SizedBox(height: AfiaSpacing.xl),
          _SettingsGroup(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About Afia',
                trailing: 'Version 1.0.0',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AfiaSpacing.sm, bottom: AfiaSpacing.sm),
          child: Text(title, style: AfiaTypography.label),
        ),
        Material(
          color: AfiaColors.surface,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i != 0)
                  const Divider(height: 1, thickness: 1, color: AfiaColors.divider),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: 2,
      ),
      leading: Icon(icon, color: AfiaColors.textSecondary, size: 22),
      title: Text(title, style: AfiaTypography.cardTitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: AfiaSpacing.sm),
              child: Text(
                trailing!,
                style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary),
              ),
            ),
          const Icon(Icons.chevron_right_rounded, color: AfiaColors.textMuted),
        ],
      ),
    );
  }
}
