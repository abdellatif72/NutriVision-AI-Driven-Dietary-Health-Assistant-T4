import 'package:afia/core/error/failures.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/ai/domain/usecases/analyze_plate.dart';
import 'package:afia/features/ai/presentation/bloc/ai_bloc.dart';
import 'package:afia/features/ai/presentation/bloc/ai_event.dart';
import 'package:afia/features/ai/presentation/bloc/ai_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyzePlate extends Mock implements AnalyzePlate {}
class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late AiBloc bloc;
  late MockAnalyzePlate mockAnalyzePlate;
  late MockImagePicker mockImagePicker;

  final testFile = XFile('test.png');
  final testResult = const PlateAnalysisResult(
    foodName: 'شاورما',
    estimatedQuantityG: 250,
    calories: 420,
    proteinG: 24,
    carbsG: 30,
    fatG: 15,
    calciumMg: 80,
    vitamins: ['فيتامين سي'],
  );

  setUp(() {
    mockAnalyzePlate = MockAnalyzePlate();
    mockImagePicker = MockImagePicker();
    bloc = AiBloc(
      analyzePlate: mockAnalyzePlate,
      imagePicker: mockImagePicker,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('AiBloc PickImageEvent tests', () {
    test('emits [AiLoading, AiSuccess] when image is picked and analyzed successfully', () {
      when(() => mockImagePicker.pickImage(source: ImageSource.camera))
          .thenAnswer((_) async => testFile);
      when(() => mockAnalyzePlate(testFile))
          .thenAnswer((_) async => Right(testResult));

      final expectedStates = [
        AiLoading(),
        AiSuccess(testResult),
      ];

      expectLater(
        bloc.stream,
        emitsInOrder(expectedStates),
      );

      bloc.add(const PickImageEvent(ImageSource.camera));
    });

    test('emits nothing when image picking is cancelled', () async {
      when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => null);

      expectLater(
        bloc.stream,
        emitsInOrder([]),
      );

      bloc.add(const PickImageEvent(ImageSource.gallery));
      await Future<void>.delayed(Duration.zero);
    });

    test('emits [AiLoading, AiError] when image analysis fails', () {
      when(() => mockImagePicker.pickImage(source: ImageSource.camera))
          .thenAnswer((_) async => testFile);
      when(() => mockAnalyzePlate(testFile))
          .thenAnswer((_) async => const Left(ServerFailure('Failed to analyze plate')));

      final expectedStates = [
        AiLoading(),
        const AiError('Failed to analyze plate'),
      ];

      expectLater(
        bloc.stream,
        emitsInOrder(expectedStates),
      );

      bloc.add(const PickImageEvent(ImageSource.camera));
    });
  });
}
