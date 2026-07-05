import 'package:afia/core/widgets/afia_bar_chart_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF7F8F6),
        appBar: AppBar(title: const Text('Bar Chart Preview')),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: AfiaWeeklyBarChartCard(
            title: 'Calories',
            value: '1250',
            unit: 'Kcal',
            target: 'Target: 1920 Kcal',
            highlightedIndex: 2,
            bars: [
              (label: 'Mon', percent: 44),
              (label: 'Tue', percent: 38),
              (label: 'Wed', percent: 65),
              (label: 'Thu', percent: 100),
              (label: 'Fri', percent: 55),
              (label: 'Sat', percent: 42),
              (label: 'Sun', percent: 48),
            ],
          ),
        ),
      ),
    );
  }
}
