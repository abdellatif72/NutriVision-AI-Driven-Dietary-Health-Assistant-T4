import 'package:afia/app/di/injection_container.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealCategoryDetailPage extends StatelessWidget {
  const MealCategoryDetailPage({super.key, required this.mealEntry});

  final MealEntry mealEntry;

  String get _slotType {
    switch (mealEntry.slot) {
      case MealSlot.breakfast:
        return 'breakfast';
      case MealSlot.lunch:
        return 'lunch';
      case MealSlot.dinner:
        return 'dinner';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<MealsCubit>(),
      child: _MealCategoryDetailView(mealEntry: mealEntry, slotType: _slotType),
    );
  }
}

class _MealCategoryDetailView extends StatelessWidget {
  const _MealCategoryDetailView({
    required this.mealEntry,
    required this.slotType,
  });

  final MealEntry mealEntry;
  final String slotType;

  String _localizedSlotName(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (isAr) {
      switch (slotType) {
        case 'breakfast':
          return 'الفطور';
        case 'lunch':
          return 'الغداء';
        case 'dinner':
          return 'العشاء';
        case 'snack':
          return 'وجبة خفيفة';
        default:
          return mealEntry.title;
      }
    }
    return mealEntry.title;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<MealsCubit, MealsState>(
      builder: (context, state) {
        final slot = state.slots.firstWhere(
          (s) => s.type == slotType,
          orElse: () => MealSlotDetail(
            name: mealEntry.title,
            emoji: mealEntry.emoji,
            type: slotType,
            loggedMeals: const [],
          ),
        );

        final localizedName = _localizedSlotName(context);

        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AfiaColors.scaffoldBackground,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AfiaColors.textPrimary,
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mealEntry.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  localizedName,
                  style: AfiaTypography.screenTitle,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, RouteNames.meals),
            backgroundColor: AfiaColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            icon: const Icon(Icons.add_rounded),
            label: Text(
              isAr ? 'إضافة وجبة' : 'Add Meal',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: state.status == MealsStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AfiaColors.primary),
                  ),
                )
              : slot.loggedMeals.isEmpty
                  ? _EmptySlotView(
                      emoji: mealEntry.emoji,
                      slotName: localizedName,
                      isAr: isAr,
                      onAddTap: () =>
                          Navigator.pushNamed(context, RouteNames.meals),
                    )
                  : _SlotMealsList(slot: slot, isAr: isAr),
        );
      },
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptySlotView extends StatelessWidget {
  const _EmptySlotView({
    required this.emoji,
    required this.slotName,
    required this.isAr,
    required this.onAddTap,
  });

  final String emoji;
  final String slotName;
  final bool isAr;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AfiaSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AfiaColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 44),
                ),
              ),
            ),
            const SizedBox(height: AfiaSpacing.xl),
            Text(
              isAr ? 'لا توجد وجبات مسجلة' : 'No meals logged yet',
              style: AfiaTypography.cardTitle.copyWith(
                fontSize: 18,
                color: AfiaColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AfiaSpacing.sm),
            Text(
              isAr
                  ? 'ابدأ بإضافة وجبتك في $slotName\nلتتابع سعراتك اليومية.'
                  : 'Start by adding your $slotName meal\nto track your daily calories.',
              style: AfiaTypography.body.copyWith(
                color: AfiaColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AfiaSpacing.xxl),
            ElevatedButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add_rounded),
              label: Text(isAr ? 'إضافة وجبة' : 'Add a Meal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AfiaColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AfiaSpacing.xl),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AfiaSpacing.xxl,
                  vertical: AfiaSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Meals List ───────────────────────────────────────────────────────────────

class _SlotMealsList extends StatelessWidget {
  const _SlotMealsList({required this.slot, required this.isAr});

  final MealSlotDetail slot;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.pageMargin,
        AfiaSpacing.md,
        AfiaSpacing.pageMargin,
        120,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _SummaryHeader(slot: slot, isAr: isAr),
        const SizedBox(height: AfiaSpacing.xl),
        Text(
          isAr ? 'الوجبات المسجلة' : 'Logged Items',
          style: AfiaTypography.cardTitle.copyWith(
            fontSize: 15,
            color: AfiaColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AfiaSpacing.md),
        ...slot.loggedMeals.map(
          (meal) => _MealDetailTile(
            meal: meal,
            isAr: isAr,
            onDelete: () => context
                .read<MealsCubit>()
                .deleteMealFromSlot(slot.type, meal.id),
          ),
        ),
      ],
    );
  }
}

// ─── Summary Header ───────────────────────────────────────────────────────────

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.slot, required this.isAr});

  final MealSlotDetail slot;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AfiaSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AfiaColors.primaryContainer,
            AfiaColors.primaryContainer.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AfiaSpacing.xxl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'إجمالي' : 'Total',
                  style: AfiaTypography.label.copyWith(
                    color: AfiaColors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${slot.totalCalories}',
                      style: AfiaTypography.statValue.copyWith(
                        fontSize: 36,
                        color: AfiaColors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isAr ? 'سعرة' : 'kcal',
                      style: AfiaTypography.unit.copyWith(
                        color: AfiaColors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AfiaSpacing.md),
                Text(
                  isAr
                      ? '${slot.loggedMeals.length} عنصر مسجل'
                      : '${slot.loggedMeals.length} item${slot.loggedMeals.length == 1 ? '' : 's'} logged',
                  style: AfiaTypography.body.copyWith(
                    color: AfiaColors.onPrimaryContainer.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AfiaSpacing.md),
          _MacroColumn(
            label: isAr ? 'كارب' : 'Carbs',
            grams: slot.totalCarbs,
            color: AfiaColors.orange,
            isAr: isAr,
          ),
          const SizedBox(width: AfiaSpacing.md),
          _MacroColumn(
            label: isAr ? 'بروتين' : 'Protein',
            grams: slot.totalProtein,
            color: AfiaColors.primary,
            isAr: isAr,
          ),
          const SizedBox(width: AfiaSpacing.md),
          _MacroColumn(
            label: isAr ? 'دهون' : 'Fat',
            grams: slot.totalFat,
            color: AfiaColors.blue,
            isAr: isAr,
          ),
        ],
      ),
    );
  }
}

class _MacroColumn extends StatelessWidget {
  const _MacroColumn({
    required this.label,
    required this.grams,
    required this.color,
    required this.isAr,
  });

  final String label;
  final int grams;
  final Color color;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${grams}${isAr ? 'غ' : 'g'}',
          style: AfiaTypography.cardTitle.copyWith(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AfiaTypography.caption.copyWith(
            fontSize: 10,
            color: AfiaColors.onPrimaryContainer.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Meal Detail Tile ─────────────────────────────────────────────────────────

class _MealDetailTile extends StatelessWidget {
  const _MealDetailTile({
    required this.meal,
    required this.isAr,
    required this.onDelete,
  });

  final MealSummary meal;
  final bool isAr;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final mealName = meal.getName(isAr ? 'ar' : 'en');
    final serving = meal.getServingLabel(isAr ? 'ar' : 'en');

    return Container(
      margin: const EdgeInsets.only(bottom: AfiaSpacing.md),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AfiaColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AfiaSpacing.md),
        child: Row(
          children: [
            // Emoji avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AfiaColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  meal.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: AfiaSpacing.md),

            // Name + serving
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    style: AfiaTypography.cardTitle.copyWith(
                      fontSize: 14,
                      color: AfiaColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (serving.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      serving,
                      style: AfiaTypography.body.copyWith(
                        fontSize: 12,
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  _MacroChips(meal: meal, isAr: isAr),
                ],
              ),
            ),
            const SizedBox(width: AfiaSpacing.sm),

            // Calories + delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories}',
                  style: AfiaTypography.cardTitle.copyWith(
                    fontSize: 16,
                    color: AfiaColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  isAr ? 'سعرة' : 'kcal',
                  style: AfiaTypography.caption.copyWith(
                    fontSize: 10,
                    color: AfiaColors.textMuted,
                  ),
                ),
                const SizedBox(height: AfiaSpacing.sm),
                GestureDetector(
                  onTap: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title:
                            Text(isAr ? 'حذف الوجبة؟' : 'Remove meal?'),
                        content: Text(
                          isAr
                              ? 'هل تريد حذف "$mealName" من قائمتك؟'
                              : 'Remove "$mealName" from your log?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(isAr ? 'إلغاء' : 'Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                              isAr ? 'حذف' : 'Remove',
                              style: const TextStyle(
                                  color: AfiaColors.red),
                            ),
                          ),
                        ],
                      ),
                    ).then((confirmed) {
                      if (confirmed == true && context.mounted) {
                        onDelete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAr
                                  ? 'تمت إزالة $mealName'
                                  : 'Removed $mealName',
                            ),
                            backgroundColor: AfiaColors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AfiaColors.redContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AfiaColors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChips extends StatelessWidget {
  const _MacroChips({required this.meal, required this.isAr});

  final MealSummary meal;
  final bool isAr;

  int get _protein => (meal.calories * 0.25 / 4).round();
  int get _carbs => (meal.calories * 0.50 / 4).round();
  int get _fat => (meal.calories * 0.25 / 9).round();

  @override
  Widget build(BuildContext context) {
    final g = isAr ? 'غ' : 'g';
    return Wrap(
      spacing: 4,
      children: [
        _Chip(
            label: '${isAr ? 'ك' : 'C'} ${_carbs}$g',
            color: AfiaColors.orange),
        _Chip(
            label: '${isAr ? 'ب' : 'P'} ${_protein}$g',
            color: AfiaColors.primary),
        _Chip(
            label: '${isAr ? 'د' : 'F'} ${_fat}$g',
            color: AfiaColors.blue),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
