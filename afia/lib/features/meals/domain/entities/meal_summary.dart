import 'package:equatable/equatable.dart';

class MealSummary extends Equatable {
  const MealSummary({
    required this.id,
    required this.name,
    required this.emoji,
    required this.servingLabel,
    required this.calories,
  });

  final String id;
  final String name;
  final String emoji;
  final String servingLabel;
  final int calories;

  @override
  List<Object?> get props => [id, name, emoji, servingLabel, calories];
}
