import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  const FoodItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.emoji,
    this.categoryAr,
    this.categoryEn,
    required this.servingSizeG,
    required this.servingLabelAr,
    required this.servingLabelEn,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG,
    this.tags = const [],
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String emoji;
  final String? categoryAr;
  final String? categoryEn;
  final int servingSizeG;
  final String servingLabelAr;
  final String servingLabelEn;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? fiberG;
  final List<String> tags;

  String getName(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
  String getCategory(String languageCode) => languageCode == 'ar' ? (categoryAr ?? '') : (categoryEn ?? '');
  String getServingLabel(String languageCode) => languageCode == 'ar' ? servingLabelAr : servingLabelEn;

  @override
  List<Object?> get props => [
        id,
        nameEn,
        nameAr,
        emoji,
        categoryAr,
        categoryEn,
        servingSizeG,
        servingLabelAr,
        servingLabelEn,
        calories,
        proteinG,
        carbsG,
        fatG,
        fiberG,
        tags,
      ];
}
