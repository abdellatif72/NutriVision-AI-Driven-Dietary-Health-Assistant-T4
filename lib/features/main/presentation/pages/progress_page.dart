import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/widgets/calories_bar_chart.dart';
import 'package:afia/features/main/presentation/widgets/macro_stack_bar.dart';
import 'package:afia/features/main/presentation/widgets/period_segmented_control.dart';
import 'package:afia/features/main/presentation/widgets/weight_trend_card.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit(),
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView();

  String _macroTitle(BuildContext context, ProgressPeriod period) {
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case ProgressPeriod.week:
        return l10n.macroAverageWeek;
      case ProgressPeriod.month:
        return l10n.macroAverageMonth;
      case ProgressPeriod.year:
        return l10n.macroAverageYear;
    }
  }

  String _caloriesCaption(BuildContext context, ProgressPeriod period) {
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case ProgressPeriod.week:
        return l10n.caloriesWeekCaption;
      case ProgressPeriod.month:
        return l10n.caloriesMonthCaption;
      case ProgressPeriod.year:
        return l10n.caloriesYearCaption;
    }
  }

  String _waterCaption(BuildContext context, ProgressPeriod period) {
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case ProgressPeriod.week:
        return l10n.waterWeekCaption;
      case ProgressPeriod.month:
        return l10n.waterMonthCaption;
      case ProgressPeriod.year:
        return l10n.waterYearCaption;
    }
  }

  List<ChartBar> _localizeBars(BuildContext context, List<ChartBar> bars, ProgressPeriod period) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (!isAr) return bars;

    return List.generate(bars.length, (index) {
      final bar = bars[index];
      String newLabel = bar.label;
      String newValue = bar.value;

      if (period == ProgressPeriod.week) {
        final arWeekdays = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];
        if (index < arWeekdays.length) {
          newLabel = arWeekdays[index];
        }
      } else if (period == ProgressPeriod.month) {
        final arWeeks = ['أ١', 'أ٢', 'أ٣', 'أ٤'];
        if (index < arWeeks.length) {
          newLabel = arWeeks[index];
        }
      } else if (period == ProgressPeriod.year) {
        final arMonths = ['ي', 'ف', 'م', 'أ', 'م', 'ي', 'ي', 'أ', 'س', 'أ', 'ن', 'د'];
        if (index < arMonths.length) {
          newLabel = arMonths[index];
        }
      }

      if (newValue.endsWith('L')) {
        newValue = newValue.replaceAll('L', ' لتر');
      } else if (newValue.endsWith('k')) {
        newValue = newValue.replaceAll('k', ' ألف');
      } else if (newValue == '—') {
        newValue = '—';
      }

      return ChartBar(
        label: newLabel,
        heightPercent: bar.heightPercent,
        value: newValue,
        emphasized: bar.emphasized,
      );
    });
  }

  List<MacroSummary> _localizeMacros(BuildContext context, List<MacroSummary> macros) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return macros.map((m) {
      String newLabel = m.label;
      if (m.label.toLowerCase().contains('carb')) {
        newLabel = isAr ? 'كربوهيدرات' : 'Carbs';
      } else if (m.label.toLowerCase().contains('protein')) {
        newLabel = isAr ? 'بروتين' : 'Protein';
      } else if (m.label.toLowerCase().contains('fat')) {
        newLabel = isAr ? 'دهون' : 'Fat';
      }
      return MacroSummary(
        label: newLabel,
        grams: m.grams,
        fillPercent: m.fillPercent,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AfiaColors.scaffoldBackground,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(l10n.yourProgress, style: AfiaTypography.screenTitle),
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          final cubit = context.read<ProgressCubit>();
          return ListView(
            padding: const EdgeInsetsDirectional.only(
              top: AfiaSpacing.lg,
              bottom: AfiaSpacing.xxl,
            ),
            children: [
              PeriodSegmentedControl(
                selected: state.period,
                onChanged: cubit.selectPeriod,
              ),
              CaloriesBarChart(
                caption: _caloriesCaption(context, state.period),
                bars: _localizeBars(context, state.bars, state.period),
              ),
              MacroStackBar(
                title: _macroTitle(context, state.period),
                macros: _localizeMacros(context, state.macros),
              ),
              if (state.weight != null) WeightTrendCard(trend: state.weight!),
              CaloriesBarChart(
                caption: _waterCaption(context, state.period),
                bars: _localizeBars(context, state.waterBars, state.period),
                barColor: AfiaColors.blue,
              ),
            ],
          );
        },
      ),
    );
  }
}
