import 'package:equatable/equatable.dart';

class ProfileFormState extends Equatable {
  const ProfileFormState({
    this.name = 'Sara Khan',
    this.age = '28',
    this.gender = 'Female',
    this.heightCm = '165',
    this.weightKg = '62.4',
    this.activityLevel = 'moderate',
    this.allergies = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.isSuccess = false,
  });

  final String name;
  final String age;
  final String gender;
  final String heightCm;
  final String weightKg;
  final String activityLevel;
  final List<String> allergies;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final bool isSuccess;

  ProfileFormState copyWith({
    String? name,
    String? age,
    String? gender,
    String? heightCm,
    String? weightKg,
    String? activityLevel,
    List<String>? allergies,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool? isSuccess,
  }) {
    return ProfileFormState(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      allergies: allergies ?? this.allergies,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    name,
    age,
    gender,
    heightCm,
    weightKg,
    activityLevel,
    allergies,
    isLoading,
    isSaving,
    error,
    isSuccess,
  ];
}
