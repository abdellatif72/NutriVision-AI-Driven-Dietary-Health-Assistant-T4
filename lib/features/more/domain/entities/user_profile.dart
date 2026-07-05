import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    this.photoUrl,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.streakDays = 0,
    this.currentGoal,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? photoUrl;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final int streakDays;
  final String? currentGoal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? id,
    String? name,
    String? photoUrl,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    int? streakDays,
    String? currentGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      streakDays: streakDays ?? this.streakDays,
      currentGoal: currentGoal ?? this.currentGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    photoUrl,
    age,
    gender,
    heightCm,
    weightKg,
    activityLevel,
    streakDays,
    currentGoal,
    createdAt,
    updatedAt,
  ];
}
