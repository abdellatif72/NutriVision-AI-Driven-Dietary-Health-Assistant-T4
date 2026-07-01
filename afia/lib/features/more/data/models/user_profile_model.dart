import 'package:afia/features/more/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    super.photoUrl,
    super.age,
    super.gender,
    super.heightCm,
    super.weightKg,
    super.activityLevel,
    super.streakDays,
    super.currentGoal,
    super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      activityLevel: json['activityLevel'] as String?,
      streakDays: json['streakDays'] as int? ?? 0,
      currentGoal: json['currentGoal'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photoUrl': photoUrl,
    'age': age,
    'gender': gender,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'activityLevel': activityLevel,
    'streakDays': streakDays,
    'currentGoal': currentGoal,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      age: entity.age,
      gender: entity.gender,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      activityLevel: entity.activityLevel,
      streakDays: entity.streakDays,
      currentGoal: entity.currentGoal,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
