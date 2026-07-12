import 'package:equatable/equatable.dart';

class MoreState extends Equatable {
  const MoreState({
    this.name = '',
    this.initials = '',
    this.currentGoal = 'Balanced',
    this.streakDays = 14,
    this.weightKg = 62.4,
    this.heightCm = 165.0,
    this.isLoading = false,
  });

  final String name;
  final String initials;
  final String currentGoal;
  final int streakDays;
  final double weightKg;
  final double heightCm;
  final bool isLoading;

  MoreState copyWith({
    String? name,
    String? initials,
    String? currentGoal,
    int? streakDays,
    double? weightKg,
    double? heightCm,
    bool? isLoading,
  }) {
    return MoreState(
      name: name ?? this.name,
      initials: initials ?? this.initials,
      currentGoal: currentGoal ?? this.currentGoal,
      streakDays: streakDays ?? this.streakDays,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    name,
    initials,
    currentGoal,
    streakDays,
    weightKg,
    heightCm,
    isLoading,
  ];
}
