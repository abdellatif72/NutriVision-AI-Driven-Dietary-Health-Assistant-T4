import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/widgets/afia_bottom_nav.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:afia/features/meals/presentation/widgets/meal_ai_suggestion_card.dart';
import 'package:afia/features/meals/presentation/widgets/meal_date_selector.dart';
import 'package:afia/features/meals/presentation/widgets/meal_log_card.dart';
import 'package:afia/features/meals/presentation/widgets/meal_quick_actions.dart';
import 'package:afia/features/meals/presentation/widgets/meals_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealsCubit(),
      child: const _MealsPageView(),
    );
  }
}

class _MealsPageView extends StatelessWidget {
  const _MealsPageView();

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, RouteNames.main);
        return;
      case 1:
        // Already on meals page
        return;
      case 2:
        Navigator.pushReplacementNamed(context, RouteNames.ai);
        return;
      case 3:
        Navigator.pushReplacementNamed(context, RouteNames.more);
        return;
    }
  }

  void _showSlotSelectionSheet(BuildContext context, MealSummary meal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AfiaColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Add to which meal slot?',
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: 16),
                _SlotSelectionTile(
                  emoji: '🥣',
                  title: 'Breakfast',
                  onTap: () {
                    context.read<MealsCubit>().addMealToSlot('breakfast', meal);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${meal.name} added to Breakfast'),
                        backgroundColor: AfiaColors.primary,
                      ),
                    );
                  },
                ),
                _SlotSelectionTile(
                  emoji: '🥗',
                  title: 'Lunch',
                  onTap: () {
                    context.read<MealsCubit>().addMealToSlot('lunch', meal);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${meal.name} added to Lunch'),
                        backgroundColor: AfiaColors.primary,
                      ),
                    );
                  },
                ),
                _SlotSelectionTile(
                  emoji: '🍛',
                  title: 'Dinner',
                  onTap: () {
                    context.read<MealsCubit>().addMealToSlot('dinner', meal);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${meal.name} added to Dinner'),
                        backgroundColor: AfiaColors.primary,
                      ),
                    );
                  },
                ),
                _SlotSelectionTile(
                  emoji: '🍎',
                  title: 'Snack',
                  onTap: () {
                    context.read<MealsCubit>().addMealToSlot('snack', meal);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${meal.name} added to Snack'),
                        backgroundColor: AfiaColors.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddMealBottomSheet(BuildContext context, [String? preSelectedSlot]) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AfiaColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  preSelectedSlot != null
                      ? 'Add to ${preSelectedSlot[0].toUpperCase()}${preSelectedSlot.substring(1)}'
                      : 'Log a Meal',
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: 16),
                _ActionSheetTile(
                  icon: Icons.search_rounded,
                  title: 'Search Food',
                  subtitle: 'Search the food catalog',
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final meal = await Navigator.pushNamed<dynamic>(
                      context,
                      RouteNames.mealSearch,
                    );
                    if (meal is MealSummary) {
                      if (preSelectedSlot != null) {
                        if (context.mounted) {
                          context.read<MealsCubit>().addMealToSlot(preSelectedSlot, meal);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${meal.name} added to ${preSelectedSlot[0].toUpperCase()}${preSelectedSlot.substring(1)}'),
                              backgroundColor: AfiaColors.primary,
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          _showSlotSelectionSheet(context, meal);
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  iconWidget: Stack(
                    children: const [
                      Icon(
                        Icons.camera_alt_rounded,
                        size: 28,
                        color: AfiaColors.primary,
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: AfiaColors.primary,
                        ),
                      ),
                    ],
                  ),
                  title: 'AI Smart Scan / Suggestion',
                  subtitle: 'Get nutrition suggestion using AI',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(context, RouteNames.ai);
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'Saved Meals',
                  subtitle: 'Log from your saved favorites',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showPlaceholderSheet(
                      context,
                      'Saved Meals',
                      'Quickly log your favorite meals in one tap.',
                      'This feature is coming soon in the next update!',
                    );
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.edit_note_rounded,
                  title: 'Manual Entry',
                  subtitle: 'Log custom meal calories',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showPlaceholderSheet(
                      context,
                      'Manual Entry',
                      'Log custom calories and nutrients.',
                      'Manual logging will be available in the next version.',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPlaceholderSheet(
    BuildContext context,
    String title,
    String subtitle,
    String description,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AfiaColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AfiaColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: AfiaColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AfiaTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AfiaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AfiaTypography.body.copyWith(
                    fontSize: 13,
                    color: AfiaColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AfiaColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMealDetailBottomSheet(
    BuildContext context,
    MealSlotDetail slot,
    MealSummary meal,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AfiaColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AfiaColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          meal.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: AfiaTypography.cardTitle.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${slot.name} Slot',
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: AfiaColors.divider, height: 1),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AfiaColors.orange,
                  label: 'Calories',
                  value: '${meal.calories} kcal',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.scale_rounded,
                  iconColor: AfiaColors.primary,
                  label: 'Serving Size',
                  value: meal.servingLabel,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.access_time_rounded,
                  iconColor: AfiaColors.blue,
                  label: 'Logged Time',
                  value: 'Today',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _showPlaceholderSheet(
                            context,
                            'Edit Meal',
                            'Modify serving details.',
                            'Editing logged meals will be available in the next version.',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AfiaColors.textPrimary,
                          side: const BorderSide(color: AfiaColors.divider),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<MealsCubit>().deleteMealFromSlot(slot.type, meal.id);
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Removed ${meal.name}'),
                              backgroundColor: AfiaColors.red,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AfiaColors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: AfiaTypography.body.copyWith(
            color: AfiaColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AfiaTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: AfiaColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsCubit, MealsState>(
      builder: (context, state) {
        final loggedCount = state.slots.where((s) => s.isLogged).length;

        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AfiaColors.scaffoldBackground,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Meals',
              style: AfiaTypography.screenTitle,
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
                icon: const Icon(Icons.settings_outlined, color: AfiaColors.textPrimary),
              ),
            ],
          ),
          body: state.status == MealsStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AfiaColors.primary,
                    strokeWidth: 2.4,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AfiaSpacing.pageMargin,
                    vertical: AfiaSpacing.md,
                  ),
                  children: [
                    // Date Selector
                    MealDateSelector(
                      selectedDate: state.selectedDate,
                      onDateChanged: (newDate) {
                        context.read<MealsCubit>().selectDate(newDate);
                      },
                    ),
                    const SizedBox(height: AfiaSpacing.md),

                    // Summary Card
                    MealsSummaryCard(
                      mealsLoggedCount: loggedCount,
                      mealsTotalCount: state.slots.length,
                      consumedCalories: state.consumedCalories,
                      calorieGoal: state.calorieGoal,
                      remainingCalories: state.remainingCalories,
                      progress: state.progress,
                      carbs: state.carbs,
                      carbsGoal: state.carbsGoal,
                      protein: state.protein,
                      proteinGoal: state.proteinGoal,
                      fat: state.fat,
                      fatGoal: state.fatGoal,
                    ),
                    const SizedBox(height: AfiaSpacing.lg),

                    // Quick Actions
                    MealQuickActions(
                      onAddMealTap: () => _showAddMealBottomSheet(context),
                      onSavedMealsTap: () {
                        _showPlaceholderSheet(
                          context,
                          'Saved Meals',
                          'Quickly log your favorite meals in one tap.',
                          'This feature is coming soon in the next update!',
                        );
                      },
                    ),
                    const SizedBox(height: AfiaSpacing.lg),

                    // Today's Plan Header
                    Text(
                      'Today’s plan',
                      style: AfiaTypography.cardTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: AfiaSpacing.sm),

                    // Slots list
                    ...state.slots.map((slot) {
                      return MealLogCard(
                        slot: slot,
                        onAddTap: () => _showAddMealBottomSheet(context, slot.type),
                        onMealTap: (meal) => _showMealDetailBottomSheet(context, slot, meal),
                      );
                    }),
                    const SizedBox(height: AfiaSpacing.sm),

                    // AI Suggestion Banner
                    MealAiSuggestionCard(
                      onTap: () => Navigator.pushNamed(context, RouteNames.ai),
                    ),
                    const SizedBox(height: AfiaSpacing.xxl),
                  ],
                ),
          bottomNavigationBar: AfiaBottomNav(
            items: const [
              AfiaNavItem(icon: Icons.home_rounded, label: 'Home'),
              AfiaNavItem(icon: Icons.restaurant_menu_rounded, label: 'Meals'),
              AfiaNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
              AfiaNavItem(icon: Icons.more_horiz_rounded, label: 'More'),
            ],
            selectedIndex: 1,
            onSelected: (index) => _onNavTap(context, index),
            centerIcon: Icons.add_rounded,
            onCenterTap: () => _showAddMealBottomSheet(context),
          ),
        );
      },
    );
  }
}

class _SlotSelectionTile extends StatelessWidget {
  const _SlotSelectionTile({
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AfiaColors.trackInactive.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AfiaColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AfiaColors.textMuted),
      onTap: onTap,
    );
  }
}

class _ActionSheetTile extends StatelessWidget {
  const _ActionSheetTile({
    this.icon,
    this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : assert(
          icon != null || iconWidget != null,
          'Either icon or iconWidget must be provided',
        );

  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: iconWidget ??
                      Icon(icon, size: 28, color: AfiaColors.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AfiaColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
