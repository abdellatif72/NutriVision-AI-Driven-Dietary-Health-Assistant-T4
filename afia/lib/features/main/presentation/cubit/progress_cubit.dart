import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:afia/features/main/presentation/cubit/home_cubit.dart';

enum ProgressPeriod {
  week(label: 'Last week'),
  month(label: 'Last month'),
  year(label: 'Last year');

  const ProgressPeriod({required this.label});

  final String label;
}

class ChartBar extends Equatable {
  const ChartBar({
    required this.label,
    required this.heightPercent,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final double heightPercent;
  final String value;
  final bool emphasized;

  @override
  List<Object?> get props => [label, heightPercent, value, emphasized];
}

class WeightTrend extends Equatable {
  const WeightTrend({
    required this.startKg,
    required this.endKg,
    required this.points,
    required this.caption,
  });

  final double startKg;
  final double endKg;
  final List<double> points;
  final String caption;

  double get deltaKg => endKg - startKg;

  @override
  List<Object?> get props => [startKg, endKg, points, caption];
}

class ProgressState extends Equatable {
  const ProgressState({
    this.period = ProgressPeriod.week,
    this.chartCaption = '',
    this.bars = const [],
    this.macros = const [],
    this.weight,
    this.water,
    this.waterChartCaption = '',
    this.waterBars = const [],
  });

  final ProgressPeriod period;
  final String chartCaption;
  final List<ChartBar> bars;
  final List<MacroSummary> macros;
  final WeightTrend? weight;
  final WaterSummary? water;
  final String waterChartCaption;
  final List<ChartBar> waterBars;

  ProgressState copyWith({
    ProgressPeriod? period,
    String? chartCaption,
    List<ChartBar>? bars,
    List<MacroSummary>? macros,
    WeightTrend? weight,
    WaterSummary? water,
    String? waterChartCaption,
    List<ChartBar>? waterBars,
  }) {
    return ProgressState(
      period: period ?? this.period,
      chartCaption: chartCaption ?? this.chartCaption,
      bars: bars ?? this.bars,
      macros: macros ?? this.macros,
      weight: weight ?? this.weight,
      water: water ?? this.water,
      waterChartCaption: waterChartCaption ?? this.waterChartCaption,
      waterBars: waterBars ?? this.waterBars,
    );
  }

  @override
  List<Object?> get props => [
    period,
    chartCaption,
    bars,
    macros,
    weight,
    water,
    waterChartCaption,
    waterBars,
  ];
}

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(const ProgressState()) {
    selectPeriod(ProgressPeriod.week);
  }

  void selectPeriod(ProgressPeriod period) {
    emit(_buildMockState(period));
  }

  ProgressState _buildMockState(ProgressPeriod period) {
    switch (period) {
      case ProgressPeriod.week:
        return const ProgressState(
          period: ProgressPeriod.week,
          chartCaption: 'Calories — last week (day by day)',
          bars: [
            ChartBar(label: 'M', heightPercent: 0.60, value: '1800'),
            ChartBar(
              label: 'T',
              heightPercent: 0.80,
              value: '2100',
              emphasized: true,
            ),
            ChartBar(label: 'W', heightPercent: 0.70, value: '1950'),
            ChartBar(
              label: 'T',
              heightPercent: 0.50,
              value: '1420',
              emphasized: true,
            ),
            ChartBar(label: 'F', heightPercent: 0.0, value: '—'),
            ChartBar(label: 'S', heightPercent: 0.0, value: '—'),
            ChartBar(label: 'S', heightPercent: 0.0, value: '—'),
          ],
          macros: [
            MacroSummary(label: 'Carb', grams: 142, fillPercent: 0.45),
            MacroSummary(label: 'Protein', grams: 89, fillPercent: 0.30),
            MacroSummary(label: 'Fat', grams: 38, fillPercent: 0.25),
          ],
          weight: WeightTrend(
            startKg: 81.2,
            endKg: 80.6,
            points: [0.05, 0.20, 0.35, 0.55, 0.72, 0.90],
            caption: 'During the last week',
          ),
          water: WaterSummary(consumedLiters: 1.5, goalLiters: 2.4),
          waterChartCaption: 'Water — last week (day by day)',
          waterBars: [
            ChartBar(label: 'M', heightPercent: 0.75, value: '1.8L'),
            ChartBar(
              label: 'T',
              heightPercent: 0.88,
              value: '2.1L',
              emphasized: true,
            ),
            ChartBar(label: 'W', heightPercent: 0.50, value: '1.2L'),
            ChartBar(
              label: 'T',
              heightPercent: 0.96,
              value: '2.3L',
              emphasized: true,
            ),
            ChartBar(label: 'F', heightPercent: 0.62, value: '1.5L'),
            ChartBar(label: 'S', heightPercent: 0.0, value: '—'),
            ChartBar(label: 'S', heightPercent: 0.0, value: '—'),
          ],
        );
      case ProgressPeriod.month:
        return const ProgressState(
          period: ProgressPeriod.month,
          chartCaption: 'Average calories per week — last 4 weeks',
          bars: [
            ChartBar(label: 'W1', heightPercent: 0.55, value: '1.9k'),
            ChartBar(
              label: 'W2',
              heightPercent: 0.72,
              value: '2.1k',
              emphasized: true,
            ),
            ChartBar(label: 'W3', heightPercent: 0.68, value: '2.0k'),
            ChartBar(
              label: 'W4',
              heightPercent: 0.45,
              value: '1.7k',
              emphasized: true,
            ),
          ],
          macros: [
            MacroSummary(label: 'Carb', grams: 156, fillPercent: 0.50),
            MacroSummary(label: 'Protein', grams: 94, fillPercent: 0.32),
            MacroSummary(label: 'Fat', grams: 42, fillPercent: 0.18),
          ],
          weight: WeightTrend(
            startKg: 82.4,
            endKg: 80.6,
            points: [0.10, 0.30, 0.50, 0.70, 0.85, 0.95],
            caption: 'During the last month',
          ),
          water: WaterSummary(consumedLiters: 1.8, goalLiters: 2.4),
          waterChartCaption: 'Average water per week — last 4 weeks',
          waterBars: [
            ChartBar(label: 'W1', heightPercent: 0.65, value: '1.6L'),
            ChartBar(
              label: 'W2',
              heightPercent: 0.88,
              value: '2.1L',
              emphasized: true,
            ),
            ChartBar(label: 'W3', heightPercent: 0.71, value: '1.7L'),
            ChartBar(
              label: 'W4',
              heightPercent: 0.54,
              value: '1.3L',
              emphasized: true,
            ),
          ],
        );
      case ProgressPeriod.year:
        return const ProgressState(
          period: ProgressPeriod.year,
          chartCaption: 'Approximate daily average per month — last 12 months',
          bars: [
            ChartBar(label: 'J', heightPercent: 0.40, value: ''),
            ChartBar(label: 'F', heightPercent: 0.48, value: ''),
            ChartBar(
              label: 'M',
              heightPercent: 0.55,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'A', heightPercent: 0.52, value: ''),
            ChartBar(
              label: 'M',
              heightPercent: 0.58,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'J', heightPercent: 0.62, value: ''),
            ChartBar(
              label: 'J',
              heightPercent: 0.65,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'A', heightPercent: 0.60, value: ''),
            ChartBar(
              label: 'S',
              heightPercent: 0.70,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'O', heightPercent: 0.68, value: ''),
            ChartBar(
              label: 'N',
              heightPercent: 0.72,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'D', heightPercent: 0.75, value: ''),
          ],
          macros: [
            MacroSummary(label: 'Carb', grams: 168, fillPercent: 0.55),
            MacroSummary(label: 'Protein', grams: 102, fillPercent: 0.30),
            MacroSummary(label: 'Fat', grams: 48, fillPercent: 0.15),
          ],
          weight: WeightTrend(
            startKg: 86.0,
            endKg: 80.6,
            points: [0.05, 0.18, 0.30, 0.42, 0.55, 0.68, 0.80, 0.92],
            caption: 'During the last year',
          ),
          water: WaterSummary(consumedLiters: 1.7, goalLiters: 2.4),
          waterChartCaption: 'Daily water average per month — last 12 months',
          waterBars: [
            ChartBar(label: 'J', heightPercent: 0.50, value: ''),
            ChartBar(label: 'F', heightPercent: 0.54, value: ''),
            ChartBar(
              label: 'M',
              heightPercent: 0.62,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'A', heightPercent: 0.58, value: ''),
            ChartBar(
              label: 'M',
              heightPercent: 0.67,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'J', heightPercent: 0.71, value: ''),
            ChartBar(
              label: 'J',
              heightPercent: 0.75,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'A', heightPercent: 0.83, value: ''),
            ChartBar(
              label: 'S',
              heightPercent: 0.79,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'O', heightPercent: 0.71, value: ''),
            ChartBar(
              label: 'N',
              heightPercent: 0.65,
              value: '',
              emphasized: true,
            ),
            ChartBar(label: 'D', heightPercent: 0.62, value: ''),
          ],
        );
    }
  }
}
