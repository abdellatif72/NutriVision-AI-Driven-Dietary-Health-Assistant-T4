import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/diet_preferences_cubit.dart';
import 'package:afia/features/more/presentation/cubit/diet_preferences_state.dart';
import 'package:afia/features/more/presentation/widgets/form_card.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DietPreferencesPage extends StatelessWidget {
  const DietPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DietPreferencesCubit(),
      child: const _DietPreferencesView(),
    );
  }
}

class _DietPreferencesView extends StatelessWidget {
  const _DietPreferencesView();

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
        title: Text('Diet Preferences', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: BlocListener<DietPreferencesCubit, DietPreferencesState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Preferences saved')));
            context.read<DietPreferencesCubit>().resetSuccess();
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<DietPreferencesCubit, DietPreferencesState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AfiaSpacing.pageMargin,
                AfiaSpacing.xl,
                AfiaSpacing.pageMargin,
                AfiaSpacing.xxxl,
              ),
              children: [
                const SectionTitle('Diet Style'),
                const SizedBox(height: AfiaSpacing.md),
                _buildChipGroup(
                  context,
                  ['balanced', 'low-carb', 'keto', 'vegan', 'mediterranean'],
                  state.dietStyle,
                  (v) =>
                      context.read<DietPreferencesCubit>().updateDietStyle(v),
                ),
                const SizedBox(height: AfiaSpacing.xl),
                const SectionTitle('Goal'),
                const SizedBox(height: AfiaSpacing.md),
                _buildChipGroup(
                  context,
                  ['lose', 'maintain', 'gain'],
                  state.goalType,
                  (v) => context.read<DietPreferencesCubit>().updateGoalType(v),
                ),
                const SizedBox(height: AfiaSpacing.xl),
                const SectionTitle('Macronutrient Split'),
                const SizedBox(height: AfiaSpacing.md),
                FormCard(
                  children: [
                    _buildSliderTile(
                      'Carbs',
                      '${state.carbsPct}%',
                      state.carbsPct.toDouble(),
                      AfiaColors.orange,
                      (v) => context
                          .read<DietPreferencesCubit>()
                          .updateCarbsPct(v.round()),
                    ),
                    const _PrefDivider(),
                    _buildSliderTile(
                      'Protein',
                      '${state.proteinPct}%',
                      state.proteinPct.toDouble(),
                      AfiaColors.blue,
                      (v) => context
                          .read<DietPreferencesCubit>()
                          .updateProteinPct(v.round()),
                    ),
                    const _PrefDivider(),
                    _buildSliderTile(
                      'Fat',
                      '${state.fatPct}%',
                      state.fatPct.toDouble(),
                      AfiaColors.primary,
                      (v) => context.read<DietPreferencesCubit>().updateFatPct(
                        v.round(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AfiaSpacing.xl),
                const SectionTitle('Allergies'),
                const SizedBox(height: AfiaSpacing.md),
                _buildChipGroup(
                  context,
                  ['Gluten', 'Dairy', 'Nuts', 'Eggs', 'Soy', 'Seafood'],
                  '',
                  (v) => context.read<DietPreferencesCubit>().toggleAllergy(v),
                  isMultiSelect: true,
                  selectedValues: state.allergies,
                ),
                const SizedBox(height: AfiaSpacing.xl),
                const SectionTitle('Meals Per Day'),
                const SizedBox(height: AfiaSpacing.md),
                _buildChipGroup(
                  context,
                  ['2', '3', '4', '5'],
                  state.mealsPerDay.toString(),
                  (v) => context.read<DietPreferencesCubit>().updateMealsPerDay(
                    int.parse(v),
                  ),
                ),
                const SizedBox(height: AfiaSpacing.xl),
                const SectionTitle('Water Goal'),
                const SizedBox(height: AfiaSpacing.md),
                FormCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AfiaSpacing.lg,
                        vertical: AfiaSpacing.md,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            color: AfiaColors.blue,
                          ),
                          const SizedBox(width: AfiaSpacing.sm),
                          Text(
                            '${state.waterGoalMl} ml',
                            style: AfiaTypography.cardTitle,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: state.waterGoalMl > 1000
                                ? () => context
                                      .read<DietPreferencesCubit>()
                                      .updateWaterGoal(state.waterGoalMl - 100)
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: state.waterGoalMl < 5000
                                ? () => context
                                      .read<DietPreferencesCubit>()
                                      .updateWaterGoal(state.waterGoalMl + 100)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AfiaSpacing.xxxl),
                FilledButton(
                  onPressed: state.isSaving
                      ? null
                      : () => context.read<DietPreferencesCubit>().save(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AfiaColors.primary,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: state.isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AfiaColors.onPrimary,
                          ),
                        )
                      : Text(
                          'Save Preferences',
                          style: AfiaTypography.cardTitle.copyWith(
                            color: AfiaColors.onPrimary,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChipGroup(
    BuildContext context,
    List<String> options,
    String selected,
    ValueChanged<String> onChanged, {
    bool isMultiSelect = false,
    List<String> selectedValues = const [],
  }) {
    return FormCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(AfiaSpacing.md),
          child: Wrap(
            spacing: AfiaSpacing.sm,
            runSpacing: AfiaSpacing.sm,
            children: options.map((option) {
              final isSelected = isMultiSelect
                  ? selectedValues.contains(option)
                  : selected == option;
              return ChoiceChip(
                label: Text(
                  _labelFor(option),
                  style: AfiaTypography.body.copyWith(
                    color: isSelected
                        ? AfiaColors.onPrimary
                        : AfiaColors.textPrimary,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onChanged(option),
                selectedColor: AfiaColors.primary,
                backgroundColor: AfiaColors.scaffoldBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderTile(
    String label,
    String value,
    double sliderValue,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AfiaSpacing.lg,
        AfiaSpacing.sm,
        AfiaSpacing.lg,
        AfiaSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AfiaTypography.cardTitle),
              const Spacer(),
              Text(value, style: AfiaTypography.body),
            ],
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: onChanged,
            activeColor: color,
            inactiveColor: AfiaColors.trackInactive,
          ),
        ],
      ),
    );
  }

  String _labelFor(String key) {
    switch (key) {
      case 'balanced':
        return 'Balanced';
      case 'low-carb':
        return 'Low Carb';
      case 'keto':
        return 'Keto';
      case 'vegan':
        return 'Vegan';
      case 'mediterranean':
        return 'Mediterranean';
      case 'lose':
        return 'Lose Weight';
      case 'maintain':
        return 'Maintain';
      case 'gain':
        return 'Gain Weight';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }
}

class _PrefDivider extends StatelessWidget {
  const _PrefDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AfiaColors.divider);
  }
}
