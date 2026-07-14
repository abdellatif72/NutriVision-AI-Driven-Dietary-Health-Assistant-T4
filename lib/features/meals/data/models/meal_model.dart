import 'package:afia/features/meals/domain/entities/meal_summary.dart';

class MealModel extends MealSummary {
  const MealModel({
    required super.id,
    required super.name,
    required super.emoji,
    required super.servingLabel,
    required super.calories,
    super.nameAr,
    super.servingLabelAr,
    super.tags,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.slotType,
  });

  final int? proteinG;
  final int? carbsG;
  final int? fatG;
  final String? slotType;

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final tagsJson = json['tags'];
    final List<String> tagsList = tagsJson != null 
        ? List<String>.from(tagsJson as Iterable) 
        : const [];

    return MealModel(
      id: json['id'] as String,
      name: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      emoji: json['emoji'] as String? ?? '🍽️',
      servingLabel: json['serving_label_en'] as String? ?? '',
      servingLabelAr: json['serving_label_ar'] as String?,
      calories: json['calories'] as int? ?? 0,
      tags: tagsList,
      proteinG: json['protein_g'] as int?,
      carbsG: json['carbs_g'] as int?,
      fatG: json['fat_g'] as int?,
      slotType: json['slot_type'] as String?,
    );
  }

  Map<String, dynamic> toJson(String userId, String slotType, DateTime date) {
    final p = proteinG ?? (calories * 0.25 / 4).round();
    final c = carbsG ?? (calories * 0.50 / 4).round();
    final f = fatG ?? (calories * 0.25 / 9).round();

    return {
      'id': id,
      'user_id': userId,
      'name_en': name,
      'name_ar': nameAr,
      'emoji': emoji,
      'serving_label_en': servingLabel,
      'serving_label_ar': servingLabelAr,
      'calories': calories,
      'protein_g': p,
      'carbs_g': c,
      'fat_g': f,
      'tags': tags,
      'slot_type': slotType,
      'logged_date': date.toIso8601String().substring(0, 10),
    };
  }

  factory MealModel.fromEntity(MealSummary entity, {int? proteinG, int? carbsG, int? fatG, String? slotType}) {
    return MealModel(
      id: entity.id,
      name: entity.name,
      nameAr: entity.nameAr,
      emoji: entity.emoji,
      servingLabel: entity.servingLabel,
      servingLabelAr: entity.servingLabelAr,
      calories: entity.calories,
      tags: entity.tags,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      slotType: slotType,
    );
  }
}
