import 'package:afia/core/widgets/afia_week_calendar.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:flutter/material.dart';

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AfiaColors.scaffoldBackground,
        appBar: AppBar(title: const Text('Week Calendar Preview')),
        body: const Padding(
          padding: EdgeInsets.all(AfiaSpacing.pageMargin),
          child: _CalendarExample(),
        ),
      ),
    );
  }
}

class _CalendarExample extends StatefulWidget {
  const _CalendarExample();

  @override
  State<_CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<_CalendarExample> {
  int _selectedIndex = 2;

  static const _days = [
    (weekday: 'M', date: '17'),
    (weekday: 'T', date: '18'),
    (weekday: 'W', date: '19'),
    (weekday: 'T', date: '20'),
    (weekday: 'F', date: '21'),
    (weekday: 'S', date: '22'),
    (weekday: 'S', date: '23'),
  ];

  @override
  Widget build(BuildContext context) {
    return AfiaWeekCalendar(
      monthLabel: 'August 2025',
      days: _days,
      selectedIndex: _selectedIndex,
      onSelected: (i) => setState(() => _selectedIndex = i),
      onPrevious: () => _snack('Previous month'),
      onNext: () => _snack('Next month'),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 600)),
    );
  }
}
