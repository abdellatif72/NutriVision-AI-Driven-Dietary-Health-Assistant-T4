import 'package:afia/features/explore/domain/entities/food_item.dart';

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.emoji,
    super.categoryAr,
    super.categoryEn,
    required super.servingSizeG,
    required super.servingLabelAr,
    required super.servingLabelEn,
    required super.calories,
    required super.proteinG,
    required super.carbsG,
    required super.fatG,
    super.fiberG,
    super.tags = const [],
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    // Safely parse tags
    final tagsRaw = json['tags'];
    List<String> parsedTags = [];
    if (tagsRaw is List) {
      parsedTags = tagsRaw.map((e) => e.toString()).toList();
    } else if (tagsRaw is String) {
      parsedTags = tagsRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return FoodItemModel(
      id: json['id'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '🍲',
      categoryAr: json['category_ar'] as String?,
      categoryEn: json['category_en'] as String?,
      servingSizeG: json['serving_size_g'] as int? ?? 100,
      servingLabelAr: json['serving_label_ar'] as String? ?? '١٠٠ غرام',
      servingLabelEn: json['serving_label_en'] as String? ?? '100 g',
      calories: json['calories'] as int? ?? 0,
      proteinG: parseDouble(json['protein_g']),
      carbsG: parseDouble(json['carbs_g']),
      fatG: parseDouble(json['fat_g']),
      fiberG: json['fiber_g'] != null ? parseDouble(json['fiber_g']) : null,
      tags: parsedTags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_ar': nameAr,
      'emoji': emoji,
      'category_ar': categoryAr,
      'category_en': categoryEn,
      'serving_size_g': servingSizeG,
      'serving_label_ar': servingLabelAr,
      'serving_label_en': servingLabelEn,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'fiber_g': fiberG,
      'tags': tags,
    };
  }
}
