import 'package:equatable/equatable.dart';

class MealSummary extends Equatable {
  const MealSummary({
    required this.id,
    required this.name,
    required this.emoji,
    required this.servingLabel,
    required this.calories,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String emoji;
  final String servingLabel;
  final int calories;
  final List<String> tags;

  @override
  List<Object?> get props => [id, name, emoji, servingLabel, calories, tags];
}
