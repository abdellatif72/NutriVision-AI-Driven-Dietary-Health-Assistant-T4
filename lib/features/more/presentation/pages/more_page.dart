import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:afia/app/localization/locale_cubit.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/more/presentation/cubit/more_cubit.dart';
import 'package:afia/features/more/presentation/cubit/more_state.dart';

import 'package:afia/features/more/presentation/widgets/more_section_card.dart';
import 'package:afia/features/more/presentation/widgets/more_tile.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userName = authState is AuthAuthenticated ? (authState.user.name ?? '') : '';
    return BlocProvider(
      create: (_) {
        final cubit = MoreCubit()..loadProfile();
        if (userName.isNotEmpty) cubit.updateName(userName);
        return cubit;
      },
      child: const _MoreView(),
    );
  }
}

class _MoreView extends StatelessWidget {
  const _MoreView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final authState = context.watch<AuthBloc>().state;
    final userEmail = authState is AuthAuthenticated ? authState.user.email : '';

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.more,
          style: AfiaTypography.screenTitle,
        ),
      ),
      body: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          return Builder(
            builder: (ctx) {
              return ListView(
                padding: EdgeInsetsDirectional.fromSTEB(
                  AfiaSpacing.pageMargin,
                  AfiaSpacing.sm,
                  AfiaSpacing.pageMargin,
                  80.0 + MediaQuery.paddingOf(ctx).bottom,
                ),
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => context.read<MoreCubit>().updateProfileImage(),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AfiaColors.primaryContainer,
                                backgroundImage: state.profileImageBytes != null
                                    ? MemoryImage(state.profileImageBytes!)
                                    : (state.profileImagePath.isNotEmpty
                                        ? (kIsWeb
                                            ? NetworkImage(state.profileImagePath)
                                            : FileImage(File(state.profileImagePath))) as ImageProvider
                                        : null),
                                child: state.profileImageBytes == null && state.profileImagePath.isEmpty
                                    ? Text(
                                        state.initials,
                                        style: AfiaTypography.statValueCompact.copyWith(
                                          color: AfiaColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    : null,
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AfiaColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AfiaSpacing.md),
                        Text(
                          state.name.isNotEmpty
                              ? state.name
                              : (authState is AuthAuthenticated ? (authState.user.name ?? '') : ''),
                          style: AfiaTypography.screenTitle.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (userEmail.isNotEmpty) ...[
                          const SizedBox(height: AfiaSpacing.xs),
                          Text(
                            userEmail,
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AfiaSpacing.xxl),
                  SectionTitle(l10n.healthGoals),
                  const SizedBox(height: AfiaSpacing.md),
                  MoreSectionCard(
                    children: [
                      MoreTile(
                        icon: Icons.person_outline,
                        title: l10n.personalInfoMoreTitle,
                        subtitle: l10n.personalInfoSubtitleMore,
                        onTap: () => Navigator.pushNamed(context, RouteNames.personalInformation),
                      ),
                      MoreTile(
                        icon: Icons.restaurant_outlined,
                        title: l10n.dietPreferences,
                        subtitle: l10n.dietPrefsSubtitleMore,
                        onTap: () => Navigator.pushNamed(context, RouteNames.dietPreferences),
                      ),
                      MoreTile(
                        icon: Icons.bar_chart_outlined,
                        title: l10n.progress,
                        subtitle: l10n.progressSubtitleMore,
                        onTap: () => Navigator.pushNamed(context, RouteNames.progress),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  SectionTitle(l10n.preferences),
                  const SizedBox(height: AfiaSpacing.md),
                  MoreSectionCard(
                    children: [
                      MoreTile(
                        icon: Icons.notifications_none_rounded,
                        title: l10n.notifications,
                        subtitle: l10n.notificationsSubtitleMore,
                        onTap: () => Navigator.pushNamed(context, RouteNames.notifications),
                      ),

                      MoreTile(
                        icon: Icons.language_rounded,
                        title: l10n.language,
                        subtitle: 'العربية, English',
                        onTap: () => _showLanguageSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  SectionTitle(l10n.security),
                  const SizedBox(height: AfiaSpacing.md),
                  MoreSectionCard(
                    children: [
                      MoreTile(
                        icon: Icons.lock_outline_rounded,
                        title: l10n.changePassword,
                        onTap: () => Navigator.pushNamed(context, RouteNames.changePassword),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  SectionTitle(l10n.support),
                  const SizedBox(height: AfiaSpacing.md),
                  MoreSectionCard(
                    children: [
                      MoreTile(
                        icon: Icons.help_outline_rounded,
                        title: l10n.faqs,
                        subtitle: l10n.faqsSubtitleMore,
                        onTap: () => Navigator.pushNamed(context, RouteNames.faqs),
                      ),
                      MoreTile(
                        icon: Icons.headset_mic_outlined,
                        title: l10n.help,
                        subtitle: l10n.helpSubtitleMore,
                        onTap: () => Navigator.pushNamed(context, RouteNames.help),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  SectionTitle(l10n.about),
                  const SizedBox(height: AfiaSpacing.md),
                  MoreSectionCard(
                    children: [
                      MoreTile(
                        icon: Icons.info_outline_rounded,
                        title: l10n.aboutAfia,
                        subtitle: l10n.version('1.0.0'),
                        onTap: () => Navigator.pushNamed(context, RouteNames.about),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xxxl),
                  TextButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(l10n.logOut),
                    style: TextButton.styleFrom(
                      foregroundColor: AfiaColors.red,
                      alignment: AlignmentDirectional.centerStart,
                      padding: const EdgeInsetsDirectional.symmetric(
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
          );
        },
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (_) {
        return BlocBuilder<LocaleCubit, Locale>(
          bloc: localeCubit,
          builder: (ctx, currentLocale) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AfiaColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.appLanguage, style: AfiaTypography.screenTitle),
                    const SizedBox(height: 12),
                    ...[
                      ('ar', 'العربية', '🇸🇦'),
                      ('en', 'English', '🇺🇸'),
                    ].map(
                      (entry) => ListTile(
                        leading: Text(entry.$3, style: const TextStyle(fontSize: 24)),
                        title: Text(entry.$2, style: AfiaTypography.cardTitle),
                        trailing: currentLocale.languageCode == entry.$1
                            ? const Icon(Icons.check_circle_rounded, color: AfiaColors.primary)
                            : null,
                        onTap: () {
                          localeCubit.setLocale(entry.$1);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.logoutConfirm),
          content: Text(l10n.logoutSubtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.auth,
                  (_) => false,
                );
              },
              child: Text(l10n.logOut),
            ),
          ],
        );
      },
    );
  }
}
