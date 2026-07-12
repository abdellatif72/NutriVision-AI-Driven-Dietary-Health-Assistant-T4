import 'package:equatable/equatable.dart';

class MealSummary extends Equatable {
  const MealSummary({
    required this.id,
    required this.name,
    required this.emoji,
    required this.servingLabel,
    required this.calories,
    this.nameAr,
    this.servingLabelAr,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String? nameAr;
  final String emoji;
  final String servingLabel;
  final String? servingLabelAr;
  final int calories;
  final List<String> tags;

  String getName(String languageCode) => (languageCode == 'ar' && nameAr != null) ? nameAr! : name;
  String getServingLabel(String languageCode) => (languageCode == 'ar' && servingLabelAr != null) ? servingLabelAr! : servingLabel;

  @override
  List<Object?> get props => [id, name, nameAr, emoji, servingLabel, servingLabelAr, calories, tags];
}

