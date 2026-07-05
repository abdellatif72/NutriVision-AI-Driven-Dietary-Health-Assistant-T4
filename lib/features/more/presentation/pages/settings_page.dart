import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/app_preferences_cubit.dart';
import 'package:afia/features/more/presentation/cubit/app_preferences_state.dart';
import 'package:afia/features/more/presentation/widgets/settings_group.dart';
import 'package:afia/features/more/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppPreferencesCubit(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

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
      body: BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AfiaSpacing.pageMargin,
              AfiaSpacing.sm,
              AfiaSpacing.pageMargin,
              AfiaSpacing.xxxl,
            ),
            children: [
              SettingsGroup(
                title: 'Appearance',
                children: [
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    trailing: _themeLabel(state.themeMode),
                    onTap: () => _showThemeSheet(context, state),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SettingsGroup(
                title: 'Language',
                children: [
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: 'App Language',
                    trailing: state.language == 'ar' ? 'العربية' : 'English',
                    onTap: () => _showLanguageSheet(context, state),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SettingsGroup(
                title: 'Units',
                children: [
                  SettingsTile(
                    icon: Icons.straighten_rounded,
                    title: 'Measurement System',
                    trailing: state.units == 'metric'
                        ? 'Metric (kg, cm)'
                        : 'Imperial (lb, in)',
                    onTap: () => _showUnitsSheet(context, state),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SettingsGroup(
                title: 'Account',
                children: [
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.changePassword),
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  void _showThemeSheet(BuildContext context, AppPreferencesState state) {
    showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                Text('Theme', style: AfiaTypography.screenTitle),
                const SizedBox(height: 12),
                ...['system', 'light', 'dark'].map(
                  (mode) => ListTile(
                    title: Text(
                      _themeLabel(mode),
                      style: AfiaTypography.cardTitle,
                    ),
                    trailing: mode == state.themeMode
                        ? const Icon(
                            Icons.check_circle,
                            color: AfiaColors.primary,
                          )
                        : null,
                    onTap: () {
                      context.read<AppPreferencesCubit>().setThemeMode(mode);
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
  }

  void _showLanguageSheet(BuildContext context, AppPreferencesState state) {
    showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                Text('Language', style: AfiaTypography.screenTitle),
                const SizedBox(height: 12),
                ...['ar', 'en'].map(
                  (lang) => ListTile(
                    title: Text(
                      lang == 'ar' ? 'العربية' : 'English',
                      style: AfiaTypography.cardTitle,
                    ),
                    trailing: lang == state.language
                        ? const Icon(
                            Icons.check_circle,
                            color: AfiaColors.primary,
                          )
                        : null,
                    onTap: () {
                      context.read<AppPreferencesCubit>().setLanguage(lang);
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
  }

  void _showUnitsSheet(BuildContext context, AppPreferencesState state) {
    showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                Text('Units', style: AfiaTypography.screenTitle),
                const SizedBox(height: 12),
                ...['metric', 'imperial'].map(
                  (unit) => ListTile(
                    title: Text(
                      unit == 'metric'
                          ? 'Metric (kg, cm)'
                          : 'Imperial (lb, in)',
                      style: AfiaTypography.cardTitle,
                    ),
                    trailing: unit == state.units
                        ? const Icon(
                            Icons.check_circle,
                            color: AfiaColors.primary,
                          )
                        : null,
                    onTap: () {
                      context.read<AppPreferencesCubit>().setUnits(unit);
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
  }
}
