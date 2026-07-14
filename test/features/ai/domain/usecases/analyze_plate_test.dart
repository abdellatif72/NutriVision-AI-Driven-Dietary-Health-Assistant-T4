import 'package:afia/core/error/failures.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/ai/domain/repositories/ai_repository.dart';
import 'package:afia/features/ai/domain/usecases/analyze_plate.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeAiRepository implements AiRepository {
  PlateAnalysisResult? response;
  Failure? failure;

  @override
  Future<Either<Failure, PlateAnalysisResult>> analyzePlateImage(XFile image) async {
    if (failure != null) {
      return Left(failure!);
    }

    return Right(response!);
  }
}

void main() {
  late AnalyzePlate useCase;
  late FakeAiRepository repository;

  setUp(() {
    repository = FakeAiRepository();
    useCase = AnalyzePlate(repository: repository);
  });

  test('should delegate the analysis to the repository', () async {
    final expected = const PlateAnalysisResult(
      foodName: 'شاورما',
      estimatedQuantityG: 250,
      calories: 420,
      proteinG: 24,
      carbsG: 30,
      fatG: 15,
      calciumMg: 80,
      vitamins: ['فيتامين سي'],
    );
    repository.response = expected;

    final image = XFile('test.png');
    final result = await useCase(image);

    expect(result, Right(expected));
  });
}
