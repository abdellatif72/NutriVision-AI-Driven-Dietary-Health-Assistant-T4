import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:equatable/equatable.dart';

abstract class AiState extends Equatable {
  const AiState();

  @override
  List<Object?> get props => [];
}

class AiInitial extends AiState {}

class AiLoading extends AiState {}

class AiSuccess extends AiState {
  const AiSuccess(this.result);

  final PlateAnalysisResult result;

  @override
  List<Object?> get props => [result];
}

class AiError extends AiState {
  const AiError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Emitted when the meal was successfully saved to the database.
class AiSaved extends AiState {
  const AiSaved(this.result);

  final PlateAnalysisResult result;

  @override
  List<Object?> get props => [result];
}

/// Emitted when saving failed, but the analysis result is still valid.
/// The UI should keep showing the result and let the user retry the save.
class AiSaveError extends AiState {
  const AiSaveError({required this.result, required this.message});

  final PlateAnalysisResult result;
  final String message;

  @override
  List<Object?> get props => [result, message];
}
