import 'package:afia/app/di/injection_container.dart';
import 'package:afia/app/localization/l10n.dart';
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
  const MealsPage({super.key, this.showBottomNav = true});
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MealsCubit>(),
      child: _MealsPageView(showBottomNav: showBottomNav),
    );
  }
}

class _MealsPageView extends StatelessWidget {
  const _MealsPageView({this.showBottomNav = true});
  final bool showBottomNav;

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, RouteNames.main);
        return;
      case 1:
        // Already on meals page
        return;
      case 2:
        Navigator.pushReplacementNamed(context, RouteNames.chat);
        return;
      case 3:
        Navigator.pushReplacementNamed(context, RouteNames.more);
        return;
    }
  }



  void _showAddMealBottomSheet(BuildContext context, [String? preSelectedSlot]) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final Map<String, String> slotNames = isAr
        ? {'breakfast': 'الإفطار', 'lunch': 'الغداء', 'dinner': 'العشاء', 'snack': 'الوجبات الخفيفة'}
        : {'breakfast': 'Breakfast', 'lunch': 'Lunch', 'dinner': 'Dinner', 'snack': 'Snack'};
    final slotLabel = preSelectedSlot != null
        ? (slotNames[preSelectedSlot] ?? (isAr ? preSelectedSlot : '${preSelectedSlot[0].toUpperCase()}${preSelectedSlot.substring(1)}'))
        : null;
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
                  slotLabel != null
                      ? (isAr ? 'أضف إلى $slotLabel' : 'Add to $slotLabel')
                      : (isAr ? 'تسجيل وجبة' : 'Log a Meal'),
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: 16),
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
                  title: isAr ? 'مسح / اقتراح بالذكاء الاصطناعي' : 'AI Smart Scan / Suggestion',
                  subtitle: isAr ? 'احصل على اقتراح غذائي بالذكاء الاصطناعي' : 'Get nutrition suggestion using AI',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(context, RouteNames.ai);
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.search_rounded,
                  title: isAr ? 'البحث عن وجبة' : 'Search for a Meal',
                  subtitle: isAr ? 'ابحث في قاعدة بيانات الأطعمة المتاحة' : 'Search the database of available foods',
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final meal = await Navigator.pushNamed(
                      context,
                      RouteNames.mealSearch,
                    );
                    if (meal != null && meal is MealSummary && context.mounted) {
                      context.read<MealsCubit>().addMealToSlot(preSelectedSlot ?? 'breakfast', meal);
                    }
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.explore_rounded,
                  title: isAr ? 'تصفح كتالوج الأطعمة' : 'Explore Food Catalog',
                  subtitle: isAr ? 'تصفح الأطباق العربية والحلويات بالتصنيف' : 'Browse Arabic dishes and sweets by category',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(
                      context,
                      RouteNames.explore,
                      arguments: preSelectedSlot,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.bookmark_outline_rounded,
                  title: isAr ? 'وجبات محفوظة' : 'Saved Meals',
                  subtitle: isAr ? 'سجّل من وجباتك المفضلة' : 'Log from your saved favorites',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showPlaceholderSheet(
                      context,
                      isAr ? 'وجبات محفوظة' : 'Saved Meals',
                      isAr ? 'سجّل وجباتك المفضلة بضغطة واحدة.' : 'Quickly log your favorite meals in one tap.',
                      isAr ? 'هذه الميزة ستكون متوفرة قريباً في التحديث القادم!' : 'This feature is coming soon in the next update!',
                    );
                  },
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.edit_note_rounded,
                  title: isAr ? 'إدخال يدوي' : 'Manual Entry',
                  subtitle: isAr ? 'سجّل سعرات وجبة مخصصة' : 'Log custom meal calories',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showPlaceholderSheet(
                      context,
                      isAr ? 'إدخال يدوي' : 'Manual Entry',
                      isAr ? 'سجّل سعرات ومغذيات مخصصة.' : 'Log custom calories and nutrients.',
                      isAr ? 'سيكون التسجيل اليدوي متاحاً في الإصدار القادم.' : 'Manual logging will be available in the next version.',
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
                    child: Builder(
                      builder: (ctx) {
                        final isAr = Localizations.localeOf(ctx).languageCode == 'ar';
                        return Text(isAr ? 'حسناً' : 'Got it');
                      },
                    ),
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
                          Builder(
                            builder: (ctx) {
                              final isAr = Localizations.localeOf(ctx).languageCode == 'ar';
                              final Map<String, String> slotNames = isAr
                                  ? {'breakfast': 'الإفطار', 'lunch': 'الغداء', 'dinner': 'العشاء', 'snack': 'الوجبات الخفيفة'}
                                  : {'breakfast': 'Breakfast', 'lunch': 'Lunch', 'dinner': 'Dinner', 'snack': 'Snack'};
                              final localizedSlot = slotNames[slot.type] ?? slot.name;
                              return Text(
                                isAr ? 'وجبة $localizedSlot' : '$localizedSlot Slot',
                                style: AfiaTypography.body.copyWith(
                                  color: AfiaColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: AfiaColors.divider, height: 1),
                const SizedBox(height: 16),
                Builder(
                  builder: (ctx) {
                    final isAr = Localizations.localeOf(ctx).languageCode == 'ar';
                    return Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: AfiaColors.orange,
                          label: isAr ? 'السعرات' : 'Calories',
                          value: '${meal.calories} ${isAr ? 'سعرة' : 'kcal'}',
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          icon: Icons.scale_rounded,
                          iconColor: AfiaColors.primary,
                          label: isAr ? 'حجم الحصة' : 'Serving Size',
                          value: meal.servingLabel,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          icon: Icons.access_time_rounded,
                          iconColor: AfiaColors.blue,
                          label: isAr ? 'وقت التسجيل' : 'Logged Time',
                          value: isAr ? 'اليوم' : 'Today',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (ctx) {
                    final isAr = Localizations.localeOf(ctx).languageCode == 'ar';
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              _showPlaceholderSheet(
                                context,
                                isAr ? 'تعديل الوجبة' : 'Edit Meal',
                                isAr ? 'تعديل تفاصيل الحصة.' : 'Modify serving details.',
                                isAr ? 'تعديل الوجبات المسجلة سيكون متاحاً في الإصدار القادم.' : 'Editing logged meals will be available in the next version.',
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
                            child: Text(isAr ? 'تعديل' : 'Edit'),
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
                                  content: Text(isAr ? 'تمت إزالة ${meal.name}' : 'Removed ${meal.name}'),
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
                            child: Text(isAr ? 'حذف' : 'Delete'),
                          ),
                        ),
                      ],
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
        final isAr = Localizations.localeOf(context).languageCode == 'ar';

        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AfiaColors.scaffoldBackground,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              AppLocalizations.of(context)!.meals,
              style: AfiaTypography.screenTitle,
            ),
            actions: const [],
          ),
          body: state.status == MealsStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AfiaColors.primary,
                    strokeWidth: 2.4,
                  ),
                )
              : ListView(
                  padding: EdgeInsets.only(
                    left: AfiaSpacing.pageMargin,
                    right: AfiaSpacing.pageMargin,
                    top: AfiaSpacing.md,
                    bottom: 80.0 + MediaQuery.paddingOf(context).bottom,
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
                          isAr ? 'وجبات محفوظة' : 'Saved Meals',
                          isAr ? 'سجّل وجباتك المفضلة بضغطة واحدة.' : 'Quickly log your favorite meals in one tap.',
                          isAr ? 'هذه الميزة ستكون متوفرة قريباً في التحديث القادم!' : 'This feature is coming soon in the next update!',
                        );
                      },
                    ),
                    const SizedBox(height: AfiaSpacing.lg),

                    // Today's Plan Header
                    Text(
                      isAr ? 'خطة اليوم' : 'Today’s plan',
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
          bottomNavigationBar: showBottomNav
              ? AfiaBottomNav(
                  items: const [
                    AfiaNavItem(icon: Icons.home_rounded, label: 'Home'),
                    AfiaNavItem(
                        icon: Icons.restaurant_menu_rounded, label: 'Meals'),
                    AfiaNavItem(
                        icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
                    AfiaNavItem(icon: Icons.more_horiz_rounded, label: 'More'),
                  ],
                  selectedIndex: 1,
                  onSelected: (index) => _onNavTap(context, index),
                  centerIcon: Icons.add_rounded,
                  onCenterTap: () => _showAddMealBottomSheet(context),
                )
              : null,
        );
      },
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
