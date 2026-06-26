import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:afia/features/main/presentation/widgets/calories_bar_chart.dart';
import 'package:afia/features/main/presentation/widgets/macro_stack_bar.dart';
import 'package:afia/features/main/presentation/widgets/period_segmented_control.dart';
import 'package:afia/features/main/presentation/widgets/weight_trend_card.dart';
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

  String _macroTitle(ProgressPeriod period) {
    switch (period) {
      case ProgressPeriod.week:
        return 'Average macro — last week';
      case ProgressPeriod.month:
        return 'Average macro — last month';
      case ProgressPeriod.year:
        return 'Average macro — last year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AfiaColors.scaffoldBackground,
        elevation: 0,
        title: Text('Your progress', style: AfiaTypography.screenTitle),
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          final cubit = context.read<ProgressCubit>();
          return ListView(
            padding: EdgeInsets.only(
              top: AfiaSpacing.lg,
              bottom: AfiaSpacing.xxl,
            ),
            children: [
              PeriodSegmentedControl(
                selected: state.period,
                onChanged: cubit.selectPeriod,
              ),
              CaloriesBarChart(caption: state.chartCaption, bars: state.bars),
              MacroStackBar(
                title: _macroTitle(state.period),
                macros: state.macros,
              ),
              if (state.weight != null) WeightTrendCard(trend: state.weight!),
              CaloriesBarChart(
                caption: state.waterChartCaption,
                bars: state.waterBars,
                barColor: AfiaColors.blue,
              ),
            ],
          );
        },
      ),
    );
  }
}
