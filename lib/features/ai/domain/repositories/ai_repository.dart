import 'package:afia/core/error/failures.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class AiRepository {
  Future<Either<Failure, PlateAnalysisResult>> analyzePlateImage(XFile image);
}
