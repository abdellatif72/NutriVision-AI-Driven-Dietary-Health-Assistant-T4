import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/more_cubit.dart';
import 'package:afia/features/more/presentation/cubit/more_state.dart';
import 'package:afia/features/more/presentation/widgets/more_section_card.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:afia/features/more/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<MoreCubit>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

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
              _HeroSummaryCard(
                name: state.name,
                initials: state.initials,
                currentGoal: state.currentGoal,
                streakDays: state.streakDays,
                profileImagePath: state.profileImagePath,
                profileImageBytes: state.profileImageBytes,
              ),
              const SizedBox(height: AfiaSpacing.xl),
              MoreSectionCard(
                children: [
                  SettingsTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    trailing: state.name,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.personalInformation,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.restaurant_outlined,
                    title: 'Diet Preferences',
                    trailing: state.currentGoal,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.dietPreferences,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.changePassword),
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
              const SizedBox(height: AfiaSpacing.md),
              Row(
                children: const [
                  Expanded(
                    child: _MiniInfoCard(
                      icon: Icons.water_drop_outlined,
                      label: 'Water',
                      value: '1.8 L',
                      accent: AfiaColors.blue,
                      container: AfiaColors.blueContainer,
                    ),
                  ),
                  SizedBox(width: AfiaSpacing.md),
                  Expanded(
                    child: _MiniInfoCard(
                      icon: Icons.favorite_outlined,
                      label: 'Heart Rate',
                      value: '72 bpm',
                      accent: AfiaColors.red,
                      container: AfiaColors.redContainer,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroSummaryCard extends StatelessWidget {
  const _HeroSummaryCard({
    required this.name,
    required this.initials,
    required this.currentGoal,
    required this.streakDays,
    required this.profileImagePath,
    this.profileImageBytes,
  });

  final String name;
  final String initials;
  final String currentGoal;
  final int streakDays;
  final String profileImagePath;
  final Uint8List? profileImageBytes;

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
              CircleAvatar(
                radius: 28,
                backgroundColor: AfiaColors.primaryContainer,
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes!)
                    : (profileImagePath.isNotEmpty
                        ? (kIsWeb
                            ? NetworkImage(profileImagePath)
                            : FileImage(File(profileImagePath))) as ImageProvider
                        : null),
                child: profileImageBytes == null && profileImagePath.isEmpty
                    ? Text(
                        initials,
                        style: AfiaTypography.cardTitle.copyWith(
                          color: AfiaColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AfiaTypography.cardTitle),
                    const SizedBox(height: 4),
                    Text(
                      '$currentGoal • $streakDays day streak',
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
