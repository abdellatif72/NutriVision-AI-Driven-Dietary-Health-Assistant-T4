import 'package:equatable/equatable.dart';

enum WaterPreset {
  cup(amountMl: 250, label: '250 ml', sublabel: 'cup'),
  pint(amountMl: 500, label: '500 ml', sublabel: 'pint'),
  custom(amountMl: 0, label: 'Custom', sublabel: 'amount');

  const WaterPreset({
    required this.amountMl,
    required this.label,
    required this.sublabel,
  });

  final int amountMl;
  final String label;
  final String sublabel;
}

class WaterEntry extends Equatable {
  const WaterEntry({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    required this.preset,
  });

  final String id;
  final DateTime timestamp;
  final int amountMl;
  final WaterPreset preset;

  @override
  List<Object?> get props => [id, timestamp, amountMl, preset];
}
