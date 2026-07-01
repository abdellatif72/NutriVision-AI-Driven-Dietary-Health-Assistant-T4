import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/more_cubit.dart';
import 'package:afia/features/more/presentation/cubit/more_state.dart';
import 'package:afia/features/more/presentation/widgets/more_profile_card.dart';
import 'package:afia/features/more/presentation/widgets/more_section_card.dart';
import 'package:afia/features/more/presentation/widgets/more_tile.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoreCubit()..loadProfile(),
      child: const _MoreView(),
    );
  }
}

class _MoreView extends StatelessWidget {
  const _MoreView();

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
      body: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AfiaSpacing.pageMargin,
              AfiaSpacing.sm,
              AfiaSpacing.pageMargin,
              AfiaSpacing.xxxl,
            ),
            children: [
              MoreProfileCard(
                name: state.name,
                initials: state.initials,
                currentGoal: state.currentGoal,
                streakDays: state.streakDays,
                onTap: () => Navigator.pushNamed(context, RouteNames.profile),
              ),
              const SizedBox(height: AfiaSpacing.xl),
              const SectionTitle('Health & Goals'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Age, gender, height, weight',
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.personalInformation,
                    ),
                  ),
                  MoreTile(
                    icon: Icons.restaurant_outlined,
                    title: 'Diet Preferences',
                    subtitle: 'Allergies, diet type, macros',
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.dietPreferences,
                    ),
                  ),
                  MoreTile(
                    icon: Icons.bar_chart_outlined,
                    title: 'Progress',
                    subtitle: 'Weight trends, history, milestones',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.progress),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              const SectionTitle('Preferences'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Reminders for water, meals, weigh-in',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.notifications),
                  ),
                  MoreTile(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: 'Light, Dark, System',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.settings),
                  ),
                  MoreTile(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'العربية, English',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.settings),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              const SectionTitle('Security'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.changePassword),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              const SectionTitle('Support'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQs',
                    subtitle: 'Frequently asked questions',
                    onTap: () => Navigator.pushNamed(context, RouteNames.faqs),
                  ),
                  MoreTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'Help',
                    subtitle: 'Contact support',
                    onTap: () => Navigator.pushNamed(context, RouteNames.help),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              const SectionTitle('About'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Afia',
                    subtitle: 'Version 1.0.0',
                    onTap: () => Navigator.pushNamed(context, RouteNames.about),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
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
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'This will return you to the authentication screen.',
          ),
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
