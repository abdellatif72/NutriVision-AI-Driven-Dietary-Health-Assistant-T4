import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/explore/domain/entities/food_item.dart';
import 'package:afia/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExploreBloc>()..add(const LoadCatalog()),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(BuildContext context, String categoryEn) {
    context.read<ExploreBloc>().add(CategoryChanged(categoryEn));
  }

  void _onSearchChanged(BuildContext context, String query) {
    context.read<ExploreBloc>().add(SearchQueryChanged(query));
  }

  void _showFoodDetails(BuildContext context, FoodItem food) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final exploreBloc = context.read<ExploreBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: exploreBloc,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (ctx, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle line
                    Center(
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

                    // Title & Emoji
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AfiaColors.primaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              food.emoji,
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
                                food.getName(isAr ? 'ar' : 'en'),
                                style: AfiaTypography.cardTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                food.getCategory(isAr ? 'ar' : 'en'),
                                style: AfiaTypography.body.copyWith(
                                  color: AfiaColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Nutrient Target Breakdown
                    Text(
                      isAr ? 'القيم الغذائية المرجعية (لكل ${food.getServingLabel(isAr ? 'ar' : 'en')})' : 'Reference Nutrition (per ${food.getServingLabel(isAr ? 'ar' : 'en')})',
                      style: AfiaTypography.cardTitle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    _NutritionProgressRow(
                      label: isAr ? 'السعرات الحرارية' : 'Calories',
                      value: '${food.calories} Kcal',
                      percentage: 1.0,
                      color: AfiaColors.orange,
                    ),
                    const SizedBox(height: 12),
                    _NutritionProgressRow(
                      label: isAr ? 'البروتين' : 'Protein',
                      value: '${food.proteinG} g',
                      percentage: (food.proteinG / 50.0).clamp(0.0, 1.0),
                      color: AfiaColors.red,
                    ),
                    const SizedBox(height: 12),
                    _NutritionProgressRow(
                      label: isAr ? 'الكربوهيدرات' : 'Carbohydrates',
                      value: '${food.carbsG} g',
                      percentage: (food.carbsG / 150.0).clamp(0.0, 1.0),
                      color: AfiaColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _NutritionProgressRow(
                      label: isAr ? 'الدهون' : 'Fat',
                      value: '${food.fatG} g',
                      percentage: (food.fatG / 70.0).clamp(0.0, 1.0),
                      color: AfiaColors.orange,
                    ),
                    if (food.fiberG != null && food.fiberG! > 0) ...[
                      const SizedBox(height: 12),
                      _NutritionProgressRow(
                        label: isAr ? 'الألياف' : 'Fiber',
                        value: '${food.fiberG} g',
                        percentage: (food.fiberG! / 30.0).clamp(0.0, 1.0),
                        color: AfiaColors.blue,
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Tags
                    if (food.tags.isNotEmpty) ...[
                      Text(
                        isAr ? 'الوسوم والخصائص' : 'Tags & Labels',
                        style: AfiaTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: food.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AfiaColors.scaffoldBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AfiaColors.divider),
                            ),
                            child: Text(
                              tag,
                              style: AfiaTypography.body.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AfiaColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Add to Diary button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showMealSlotSelection(ctx, food),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AfiaColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isAr ? 'أضف إلى اليوميات' : 'Add to Diary',
                          style: AfiaTypography.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showMealSlotSelection(BuildContext context, FoodItem food) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final exploreBloc = context.read<ExploreBloc>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        final slots = [
          ('breakfast', isAr ? 'الإفطار' : 'Breakfast', '🥣'),
          ('lunch', isAr ? 'الغداء' : 'Lunch', '🥗'),
          ('dinner', isAr ? 'العشاء' : 'Dinner', '🍛'),
          ('snack', isAr ? 'الوجبات الخفيفة' : 'Snacks', '🍎'),
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                  isAr ? 'اختر فترة الوجبة' : 'Select Meal Slot',
                  style: AfiaTypography.cardTitle,
                ),
                const SizedBox(height: 16),
                ...slots.map((s) {
                  return ListTile(
                    leading: Text(
                      s.$3,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      s.$2,
                      style: AfiaTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AfiaColors.textMuted,
                    ),
                    onTap: () {
                      exploreBloc.add(LogFoodItem(food: food, slotType: s.$1));
                      Navigator.pop(sheetContext); // Pop slot selection sheet
                      Navigator.pop(context); // Pop details bottom sheet
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final categories = [
      ('all', isAr ? 'الكل' : 'All'),
      ('Levantine Dishes', isAr ? 'أطباق شامية' : 'Levantine'),
      ('Egyptian Dishes', isAr ? 'أطباق مصرية' : 'Egyptian'),
      ('Arabic Sweets', isAr ? 'حلويات عربية' : 'Sweets'),
      ('Bakery', isAr ? 'مخبوزات' : 'Bakery'),
      ('Basic Ingredients', isAr ? 'مكونات أساسية' : 'Ingredients'),
      ('Vegetables', isAr ? 'خضروات' : 'Vegetables'),
      ('Fruits', isAr ? 'فواكه' : 'Fruits'),
      ('Meat', isAr ? 'لحوم' : 'Meat'),
      ('Seafood', isAr ? 'أسماك' : 'Seafood'),
      ('Dairy', isAr ? 'ألبان' : 'Dairy'),
      ('Proteins', isAr ? 'بروتينات' : 'Proteins'),
      ('Seeds', isAr ? 'بذور' : 'Seeds'),
      ('Nuts', isAr ? 'مكسرات' : 'Nuts'),
      ('Oils', isAr ? 'زيوت' : 'Oils'),
    ];

    return BlocListener<ExploreBloc, ExploreState>(
      listener: (context, state) {
        if (state.loggingStatus == LoggingStatus.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: AfiaColors.primary),
            ),
          );
        } else if (state.loggingStatus == LoggingStatus.success) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isAr ? 'تمت إضافة الوجبة بنجاح!' : 'Meal logged successfully!'),
              backgroundColor: AfiaColors.primary,
            ),
          );
        } else if (state.loggingStatus == LoggingStatus.failure) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr
                    ? 'حدث خطأ أثناء إضافة الوجبة: ${state.errorMessage}'
                    : 'Error logging meal: ${state.errorMessage}',
              ),
              backgroundColor: AfiaColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AfiaColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AfiaColors.scaffoldBackground,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: AfiaColors.textPrimary),
          ),
          title: Text(
            isAr ? 'تصفح كتالوج الأطعمة' : 'Explore Food Catalog',
            style: AfiaTypography.screenTitle,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.pageMargin,
                vertical: 8,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => _onSearchChanged(context, val),
                decoration: InputDecoration(
                  hintText: isAr
                      ? 'ابحث عن أكلات، حلويات، أو مكونات...'
                      : 'Search for foods, sweets, or ingredients...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AfiaColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AfiaColors.textSecondary,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (_, value, child) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(Icons.close_rounded, color: AfiaColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged(context, '');
                        },
                      );
                    },
                  ),
                  filled: true,
                  fillColor: AfiaColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AfiaColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AfiaColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AfiaColors.primary),
                  ),
                ),
              ),
            ),

            // Horizontal Category Chips
            BlocBuilder<ExploreBloc, ExploreState>(
              buildWhen: (previous, current) =>
                  previous.selectedCategoryEn != current.selectedCategoryEn,
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AfiaSpacing.pageMargin,
                    vertical: 8,
                  ),
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = state.selectedCategoryEn == cat.$1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            cat.$2,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : AfiaColors.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              _onCategorySelected(context, cat.$1);
                            }
                          },
                          selectedColor: AfiaColors.primary,
                          backgroundColor: AfiaColors.surface,
                          elevation: 0,
                          pressElevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : AfiaColors.divider,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            // Food Items Catalog List
            Expanded(
              child: BlocBuilder<ExploreBloc, ExploreState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status || previous.foods != current.foods,
                builder: (context, state) {
                  if (state.status == ExploreStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AfiaColors.primary,
                        strokeWidth: 2.4,
                      ),
                    );
                  }

                  if (state.status == ExploreStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: AfiaColors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isAr
                                  ? 'فشل تحميل كتالوج الأطعمة'
                                  : 'Failed to load food catalog',
                              style: AfiaTypography.cardTitle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.errorMessage ?? '',
                              textAlign: TextAlign.center,
                              style: AfiaTypography.body.copyWith(
                                color: AfiaColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<ExploreBloc>().add(const LoadCatalog()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AfiaColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.foods.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: AfiaColors.textMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isAr ? 'لم نجد أي طعام يطابق بحثك!' : 'No foods found!',
                            style: AfiaTypography.cardTitle.copyWith(
                              color: AfiaColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr
                                ? 'جرّب البحث بكلمة مختلفة أو تصنيف آخر.'
                                : 'Try searching with another word or category.',
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AfiaSpacing.pageMargin,
                      vertical: 8,
                    ),
                    itemCount: state.foods.length,
                    itemBuilder: (context, index) {
                      final food = state.foods[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: AfiaColors.divider),
                          ),
                          color: AfiaColors.surface,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showFoodDetails(context, food),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Emoji Circle bg
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AfiaColors.scaffoldBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        food.emoji,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          food.getName(isAr ? 'ar' : 'en'),
                                          style: AfiaTypography.body.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AfiaColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${food.getCategory(isAr ? 'ar' : 'en')} · ${food.getServingLabel(isAr ? 'ar' : 'en')}',
                                          style: AfiaTypography.body.copyWith(
                                            fontSize: 12,
                                            color: AfiaColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Calories
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${food.calories}',
                                        style: AfiaTypography.cardTitle.copyWith(
                                          color: AfiaColors.orange,
                                        ),
                                      ),
                                      Text(
                                        isAr ? 'سعرة' : 'Kcal',
                                        style: AfiaTypography.body.copyWith(
                                          fontSize: 10,
                                          color: AfiaColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionProgressRow extends StatelessWidget {
  const _NutritionProgressRow({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  final String label;
  final String value;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: AfiaTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AfiaColors.textPrimary,
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
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: AfiaColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
