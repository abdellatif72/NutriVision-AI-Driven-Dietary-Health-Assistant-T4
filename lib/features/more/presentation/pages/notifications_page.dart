import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/notification_preferences_cubit.dart';
import 'package:afia/features/more/presentation/cubit/notification_preferences_state.dart';
import 'package:afia/features/more/presentation/widgets/more_section_card.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationPreferencesCubit(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

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
        title: Text('Notifications', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body:
          BlocBuilder<
            NotificationPreferencesCubit,
            NotificationPreferencesState
          >(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  AfiaSpacing.pageMargin,
                  AfiaSpacing.sm,
                  AfiaSpacing.pageMargin,
                  AfiaSpacing.xxxl,
                ),
                children: [
                  SwitchListTile.adaptive(
                    value: state.enabled,
                    onChanged: (_) => context
                        .read<NotificationPreferencesCubit>()
                        .toggleEnabled(),
                    title: Text(
                      'Enable Notifications',
                      style: AfiaTypography.cardTitle,
                    ),
                    subtitle: Text('Master toggle', style: AfiaTypography.body),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AfiaSpacing.lg,
                      vertical: 4,
                    ),
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  const SectionTitle('Reminders'),
                  const SizedBox(height: AfiaSpacing.md),
                  MoreSectionCard(
                    children: [
                      _buildSwitchTile(
                        context,
                        title: 'Water Reminder',
                        subtitle: 'Every ${state.waterIntervalHours} hours',
                        value: state.waterReminder && state.enabled,
                        onChanged: (v) => context
                            .read<NotificationPreferencesCubit>()
                            .toggleWaterReminder(),
                      ),
                      if (state.waterReminder && state.enabled) ...[
                        _buildIntervalSelector(context, state),
                      ],
                      _buildSwitchTile(
                        context,
                        title: 'Meal Logging Reminder',
                        subtitle: 'Breakfast, lunch, dinner',
                        value: state.mealReminder && state.enabled,
                        onChanged: (v) => context
                            .read<NotificationPreferencesCubit>()
                            .toggleMealReminder(),
                      ),
                      _buildSwitchTile(
                        context,
                        title: 'Weekly Weigh-In',
                        subtitle: state.weighInDay,
                        value: state.weighInReminder && state.enabled,
                        onChanged: (v) => context
                            .read<NotificationPreferencesCubit>()
                            .toggleWeighInReminder(),
                      ),
                      _buildSwitchTile(
                        context,
                        title: 'Progress Summary',
                        subtitle: state.summaryFrequency == 'weekly'
                            ? 'Weekly summary'
                            : 'Monthly summary',
                        value: state.progressSummary && state.enabled,
                        onChanged: (v) => context
                            .read<NotificationPreferencesCubit>()
                            .toggleProgressSummary(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: 2,
      ),
      title: Text(title, style: AfiaTypography.cardTitle),
      subtitle: Text(subtitle, style: AfiaTypography.body),
    );
  }

  Widget _buildIntervalSelector(
    BuildContext context,
    NotificationPreferencesState state,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.lg,
        0,
        AfiaSpacing.lg,
        AfiaSpacing.sm,
      ),
      child: Row(
        children: [
          Text('Every ', style: AfiaTypography.body),
          SizedBox(
            width: 80,
            child: DropdownButtonFormField<int>(
              initialValue: state.waterIntervalHours,
              items: [1, 2, 3, 4].map((h) {
                return DropdownMenuItem(value: h, child: Text('$h h'));
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  context
                      .read<NotificationPreferencesCubit>()
                      .updateWaterInterval(v);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AfiaSpacing.sm,
                  vertical: AfiaSpacing.sm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
