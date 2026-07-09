import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

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

  Future<void> selectPeriod(ProgressPeriod period) async {
    emit(state.copyWith(period: period));
    await loadData(period);
  }

  Future<void> loadData(ProgressPeriod period) async {
    try {
      final userId = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(_buildMockState(period));
        return;
      }

      int calorieTarget = 2000;
      int waterGoalMl = 2500;
      final dietRes = await Supabase.instance.client
          .from('diet_preferences')
          .select('calorie_target, water_goal_ml')
          .eq('user_id', userId)
          .maybeSingle();
      if (dietRes != null) {
        calorieTarget = dietRes['calorie_target'] as int? ?? 2000;
        waterGoalMl = dietRes['water_goal_ml'] as int? ?? 2500;
      }

      final now = DateTime.now();
      DateTime startDate;

      switch (period) {
        case ProgressPeriod.week:
          startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
          break;
        case ProgressPeriod.month:
          startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29));
          break;
        case ProgressPeriod.year:
          startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 364));
          break;
      }

      final startDateStr = startDate.toIso8601String().substring(0, 10);

      // Fetch logged meals
      final mealsData = await Supabase.instance.client
          .from('logged_meals')
          .select('calories, protein_g, carbs_g, fat_g, logged_date')
          .eq('user_id', userId)
          .gte('logged_date', startDateStr);

      // Fetch water logs
      final waterData = await Supabase.instance.client
          .from('water_logs')
          .select('amount_ml, logged_at')
          .eq('user_id', userId)
          .gte('logged_at', startDate.toIso8601String());

      // Fetch weight history
      final weightData = await Supabase.instance.client
          .from('weight_history')
          .select('weight_kg, recorded_at')
          .eq('user_id', userId)
          .gte('recorded_at', startDate.toIso8601String())
          .order('recorded_at', ascending: true);

      // Fallback to mock data if there is absolutely no user entries
      if (mealsData.isEmpty && waterData.isEmpty && weightData.isEmpty) {
        emit(_buildMockState(period));
        return;
      }

      List<ChartBar> calorieBars = [];
      List<ChartBar> waterBars = [];
      List<MacroSummary> macros = [];
      WeightTrend? weightTrend;
      WaterSummary waterSummary;

      if (period == ProgressPeriod.week) {
        final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        int totalCal = 0;
        int totalWater = 0;
        int totalCarb = 0;
        int totalProtein = 0;
        int totalFat = 0;

        for (int i = 0; i < 7; i++) {
          final date = startDate.add(Duration(days: i));
          final dateStr = date.toIso8601String().substring(0, 10);
          final label = weekdays[(date.weekday - 1) % 7];

          final dayMeals = mealsData.where((m) => m['logged_date'] == dateStr).toList();
          final dayCal = dayMeals.fold<int>(0, (sum, m) => sum + (m['calories'] as int? ?? 0));
          totalCal += dayCal;
          totalCarb += dayMeals.fold<int>(0, (sum, m) => sum + (m['carbs_g'] as int? ?? 0));
          totalProtein += dayMeals.fold<int>(0, (sum, m) => sum + (m['protein_g'] as int? ?? 0));
          totalFat += dayMeals.fold<int>(0, (sum, m) => sum + (m['fat_g'] as int? ?? 0));

          final calHeight = calorieTarget <= 0 ? 0.0 : (dayCal / calorieTarget).clamp(0.0, 1.0);
          calorieBars.add(ChartBar(
            label: label,
            heightPercent: calHeight,
            value: dayCal > 0 ? dayCal.toString() : '—',
            emphasized: date.day == now.day && date.month == now.month && date.year == now.year,
          ));

          final dayWater = waterData.where((w) {
            final loggedDate = DateTime.parse(w['logged_at'] as String).toLocal();
            return loggedDate.year == date.year &&
                loggedDate.month == date.month &&
                loggedDate.day == date.day;
          }).fold<int>(0, (sum, w) => sum + (w['amount_ml'] as int? ?? 0));
          totalWater += dayWater;

          final waterHeight = waterGoalMl <= 0 ? 0.0 : (dayWater / waterGoalMl).clamp(0.0, 1.0);
          waterBars.add(ChartBar(
            label: label,
            heightPercent: waterHeight,
            value: dayWater > 0 ? '${(dayWater / 1000).toStringAsFixed(1)}L' : '—',
            emphasized: date.day == now.day && date.month == now.month && date.year == now.year,
          ));
        }

        final totalGrams = totalCarb + totalProtein + totalFat;
        macros = [
          MacroSummary(
            label: 'Carb',
            grams: totalCarb ~/ 7,
            fillPercent: totalGrams > 0 ? totalCarb / totalGrams : 0.5,
          ),
          MacroSummary(
            label: 'Protein',
            grams: totalProtein ~/ 7,
            fillPercent: totalGrams > 0 ? totalProtein / totalGrams : 0.2,
          ),
          MacroSummary(
            label: 'Fat',
            grams: totalFat ~/ 7,
            fillPercent: totalGrams > 0 ? totalFat / totalGrams : 0.3,
          ),
        ];

        waterSummary = WaterSummary(
          consumedLiters: (totalWater / 7) / 1000,
          goalLiters: waterGoalMl / 1000,
        );

        weightTrend = _calculateWeightTrend(weightData, 'During the last week');

      } else if (period == ProgressPeriod.month) {
        int totalCarb = 0;
        int totalProtein = 0;
        int totalFat = 0;
        int totalWater = 0;

        for (int w = 0; w < 4; w++) {
          final weekStart = startDate.add(Duration(days: w * 7));
          final weekEnd = w == 3 ? now : weekStart.add(const Duration(days: 6));

          final weekMeals = mealsData.where((m) {
            final d = DateTime.parse(m['logged_date'] as String);
            return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
          }).toList();

          final weekCal = weekMeals.fold<int>(0, (sum, m) => sum + (m['calories'] as int? ?? 0));
          final avgCal = weekMeals.isEmpty ? 0 : weekCal ~/ 7;

          totalCarb += weekMeals.fold<int>(0, (sum, m) => sum + (m['carbs_g'] as int? ?? 0));
          totalProtein += weekMeals.fold<int>(0, (sum, m) => sum + (m['protein_g'] as int? ?? 0));
          totalFat += weekMeals.fold<int>(0, (sum, m) => sum + (m['fat_g'] as int? ?? 0));

          final calHeight = calorieTarget <= 0 ? 0.0 : (avgCal / calorieTarget).clamp(0.0, 1.0);
          calorieBars.add(ChartBar(
            label: 'W${w + 1}',
            heightPercent: calHeight,
            value: avgCal > 0 ? '${(avgCal / 1000).toStringAsFixed(1)}k' : '—',
            emphasized: w == 3,
          ));

          final weekWater = waterData.where((wData) {
            final d = DateTime.parse(wData['logged_at'] as String).toLocal();
            return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
          }).fold<int>(0, (sum, wData) => sum + (wData['amount_ml'] as int? ?? 0));
          final avgWater = weekWater ~/ 7;
          totalWater += weekWater;

          final waterHeight = waterGoalMl <= 0 ? 0.0 : (avgWater / waterGoalMl).clamp(0.0, 1.0);
          waterBars.add(ChartBar(
            label: 'W${w + 1}',
            heightPercent: waterHeight,
            value: avgWater > 0 ? '${(avgWater / 1000).toStringAsFixed(1)}L' : '—',
            emphasized: w == 3,
          ));
        }

        final totalGrams = totalCarb + totalProtein + totalFat;
        macros = [
          MacroSummary(
            label: 'Carb',
            grams: totalCarb ~/ 30,
            fillPercent: totalGrams > 0 ? totalCarb / totalGrams : 0.5,
          ),
          MacroSummary(
            label: 'Protein',
            grams: totalProtein ~/ 30,
            fillPercent: totalGrams > 0 ? totalProtein / totalGrams : 0.2,
          ),
          MacroSummary(
            label: 'Fat',
            grams: totalFat ~/ 30,
            fillPercent: totalGrams > 0 ? totalFat / totalGrams : 0.3,
          ),
        ];

        waterSummary = WaterSummary(
          consumedLiters: (totalWater / 30) / 1000,
          goalLiters: waterGoalMl / 1000,
        );

        weightTrend = _calculateWeightTrend(weightData, 'During the last month');

      } else {
        final months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
        int totalCarb = 0;
        int totalProtein = 0;
        int totalFat = 0;
        int totalWater = 0;

        for (int m = 0; m < 12; m++) {
          final monthDate = DateTime(now.year, now.month - 11 + m, 1);
          final label = months[(monthDate.month - 1) % 12];

          final monthMeals = mealsData.where((meal) {
            final d = DateTime.parse(meal['logged_date'] as String);
            return d.year == monthDate.year && d.month == monthDate.month;
          }).toList();

          final monthCal = monthMeals.fold<int>(0, (sum, meal) => sum + (meal['calories'] as int? ?? 0));
          final avgCal = monthMeals.isEmpty ? 0 : monthCal ~/ 30;

          totalCarb += monthMeals.fold<int>(0, (sum, meal) => sum + (meal['carbs_g'] as int? ?? 0));
          totalProtein += monthMeals.fold<int>(0, (sum, meal) => sum + (meal['protein_g'] as int? ?? 0));
          totalFat += monthMeals.fold<int>(0, (sum, meal) => sum + (meal['fat_g'] as int? ?? 0));

          final calHeight = calorieTarget <= 0 ? 0.0 : (avgCal / calorieTarget).clamp(0.0, 1.0);
          calorieBars.add(ChartBar(
            label: label,
            heightPercent: calHeight,
            value: avgCal > 0 ? '${(avgCal / 1000).toStringAsFixed(1)}k' : '',
            emphasized: monthDate.month == now.month && monthDate.year == now.year,
          ));

          final monthWater = waterData.where((wData) {
            final d = DateTime.parse(wData['logged_at'] as String).toLocal();
            return d.year == monthDate.year && d.month == monthDate.month;
          }).fold<int>(0, (sum, wData) => sum + (wData['amount_ml'] as int? ?? 0));
          final avgWater = monthWater ~/ 30;
          totalWater += monthWater;

          final waterHeight = waterGoalMl <= 0 ? 0.0 : (avgWater / waterGoalMl).clamp(0.0, 1.0);
          waterBars.add(ChartBar(
            label: label,
            heightPercent: waterHeight,
            value: avgWater > 0 ? '${(avgWater / 1000).toStringAsFixed(1)}L' : '',
            emphasized: monthDate.month == now.month && monthDate.year == now.year,
          ));
        }

        final totalGrams = totalCarb + totalProtein + totalFat;
        macros = [
          MacroSummary(
            label: 'Carb',
            grams: totalCarb ~/ 365,
            fillPercent: totalGrams > 0 ? totalCarb / totalGrams : 0.5,
          ),
          MacroSummary(
            label: 'Protein',
            grams: totalProtein ~/ 365,
            fillPercent: totalGrams > 0 ? totalProtein / totalGrams : 0.2,
          ),
          MacroSummary(
            label: 'Fat',
            grams: totalFat ~/ 365,
            fillPercent: totalGrams > 0 ? totalFat / totalGrams : 0.3,
          ),
        ];

        waterSummary = WaterSummary(
          consumedLiters: (totalWater / 365) / 1000,
          goalLiters: waterGoalMl / 1000,
        );

        weightTrend = _calculateWeightTrend(weightData, 'During the last year');
      }

      emit(ProgressState(
        period: period,
        chartCaption: period == ProgressPeriod.week
            ? 'Calories — last week (day by day)'
            : period == ProgressPeriod.month
                ? 'Average calories per week — last 4 weeks'
                : 'Approximate daily average per month — last 12 months',
        bars: calorieBars,
        macros: macros,
        weight: weightTrend,
        water: waterSummary,
        waterChartCaption: period == ProgressPeriod.week
            ? 'Water — last week (day by day)'
            : period == ProgressPeriod.month
                ? 'Average water per week — last 4 weeks'
                : 'Daily water average per month — last 12 months',
        waterBars: waterBars,
      ));

    } catch (e) {
      AppLogger.error('Error loading progress data', e);
      emit(_buildMockState(period));
    }
  }

  WeightTrend? _calculateWeightTrend(List<Map<String, dynamic>> weightData, String caption) {
    if (weightData.isEmpty) return null;

    final weights = weightData.map((w) => (w['weight_kg'] as num).toDouble()).toList();
    final startW = weights.first;
    final endW = weights.last;

    double minW = weights.reduce((a, b) => a < b ? a : b);
    double maxW = weights.reduce((a, b) => a > b ? a : b);
    final range = maxW - minW;

    final points = weights.map((w) {
      if (range <= 0.0) return 0.5;
      return (w - minW) / range;
    }).toList();

    if (points.length == 1) {
      points.add(points[0]);
    }

    return WeightTrend(
      startKg: startW,
      endKg: endW,
      points: points,
      caption: caption,
    );
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
