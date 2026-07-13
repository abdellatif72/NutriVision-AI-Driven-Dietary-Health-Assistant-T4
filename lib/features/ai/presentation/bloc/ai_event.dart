import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object?> get props => [];
}

class AnalyzePlateRequested extends AiEvent {
  const AnalyzePlateRequested(this.image);

  final XFile image;

  @override
  List<Object?> get props => [image];
}

class ConfirmPlateAnalysis extends AiEvent {
  const ConfirmPlateAnalysis(this.result, this.slotType);

  final PlateAnalysisResult result;
  final String slotType;

  @override
  List<Object?> get props => [result, slotType];
}

class PickImageEvent extends AiEvent {
  const PickImageEvent(this.source);

  final ImageSource source;

  @override
  List<Object?> get props => [source];
}

