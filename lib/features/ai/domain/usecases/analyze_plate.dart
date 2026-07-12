import 'package:afia/core/error/failures.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/ai/domain/repositories/ai_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzePlate {
  AnalyzePlate({required this.repository});

  final AiRepository repository;

  Future<Either<Failure, PlateAnalysisResult>> call(XFile image) {
    return repository.analyzePlateImage(image);
  }
}
