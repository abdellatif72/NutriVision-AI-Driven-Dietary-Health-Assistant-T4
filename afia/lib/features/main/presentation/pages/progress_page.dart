import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/progress_cubit.dart';
import 'package:afia/features/main/presentation/widgets/calories_bar_chart.dart';
import 'package:afia/features/main/presentation/widgets/macro_stack_bar.dart';
import 'package:afia/features/main/presentation/widgets/period_segmented_control.dart';
import 'package:afia/features/main/presentation/widgets/water_quick_tile.dart';
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
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final cubit = context.read<ProgressCubit>();
        return Container(
          color: AfiaColors.scaffoldBackground,
          child: ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'Your progress 📈',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AfiaColors.textPrimary,
                  ),
                ),
              ),
              PeriodSegmentedControl(
                selected: state.period,
                onChanged: cubit.selectPeriod,
              ),
              CaloriesBarChart(
                caption: state.chartCaption,
                bars: state.bars,
              ),
              MacroStackBar(
                title: _macroTitle(state.period),
                macros: state.macros,
              ),
              if (state.weight != null) WeightTrendCard(trend: state.weight!),
              if (state.water != null) WaterQuickTile(summary: state.water!),
            ],
          ),
        );
      },
    );
  }
}
