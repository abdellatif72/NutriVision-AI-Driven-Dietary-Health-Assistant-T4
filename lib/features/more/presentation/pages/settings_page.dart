import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/app_preferences_cubit.dart';
import 'package:afia/features/more/presentation/cubit/app_preferences_state.dart';
import 'package:afia/features/more/presentation/widgets/settings_group.dart';
import 'package:afia/features/more/presentation/widgets/settings_tile.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:afia/app/localization/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsView();
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final currentLang = context.watch<LocaleCubit>().state.languageCode;

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.settings, style: AfiaTypography.screenTitle),
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
                title: l.language,
                children: [
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: l.appLanguage,
                    trailing: currentLang == 'ar' ? 'العربية' : 'English',
                    onTap: () => _showLanguageSheet(context, currentLang),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SettingsGroup(
                title: l.units,
                children: [
                  SettingsTile(
                    icon: Icons.straighten_rounded,
                    title: l.measurementSystem,
                    trailing: state.units == 'metric' ? l.metric : l.imperial,
                    onTap: () => _showUnitsSheet(context, state),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SettingsGroup(
                title: l.account,
                children: [
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: l.changePassword,
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.changePassword),
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l.privacyPolicy,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, String currentLang) {
    final l = AppLocalizations.of(context)!;
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
                Text(l.appLanguage, style: AfiaTypography.screenTitle),
                const SizedBox(height: 12),
                ...['ar', 'en'].map(
                  (lang) => ListTile(
                    title: Text(
                      lang == 'ar' ? 'العربية' : 'English',
                      style: AfiaTypography.cardTitle,
                    ),
                    trailing: lang == currentLang
                        ? const Icon(
                            Icons.check_circle,
                            color: AfiaColors.primary,
                          )
                        : null,
                    onTap: () {
                      context.read<AppPreferencesCubit>().setLanguage(lang);
                      context.read<LocaleCubit>().setLocale(lang);
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
    final l = AppLocalizations.of(context)!;
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
                Text(l.units, style: AfiaTypography.screenTitle),
                const SizedBox(height: 12),
                ...['metric', 'imperial'].map(
                  (unit) => ListTile(
                    title: Text(
                      unit == 'metric' ? l.metric : l.imperial,
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
