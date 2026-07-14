import 'package:afia/features/water/data/datasources/water_remote_datasource.dart';
import 'package:afia/features/water/data/models/water_entry_model.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWaterRemoteDataSource extends Mock implements WaterRemoteDataSource {}

void main() {
  late WaterRecordingCubit cubit;
  late MockWaterRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockRemoteDataSource = MockWaterRemoteDataSource();
  });

  group('WaterRecordingCubit', () {
    final tDate = DateTime.now();
    final tWaterModel = WaterEntryModel(
      id: '1',
      timestamp: tDate,
      amountMl: 250,
      preset: WaterPreset.cup,
    );

    test('initial state has default values', () {
      when(() => mockRemoteDataSource.getWaterLogs(any())).thenAnswer((_) async => []);
      when(() => mockRemoteDataSource.getWaterGoal()).thenAnswer((_) async => 2500);

      cubit = WaterRecordingCubit(remoteDataSource: mockRemoteDataSource);

      expect(cubit.state.goalMl, 2500);
      expect(cubit.state.consumedMl, 0);
      expect(cubit.state.entries, isEmpty);
    });

    test('loadWaterData success sets logs and goal', () async {
      when(() => mockRemoteDataSource.getWaterLogs(any())).thenAnswer((_) async => [tWaterModel]);
      when(() => mockRemoteDataSource.getWaterGoal()).thenAnswer((_) async => 2400);

      cubit = WaterRecordingCubit(remoteDataSource: mockRemoteDataSource);

      // Wait for constructor loading
      await Future.delayed(Duration.zero);

      expect(
        cubit.state,
        WaterRecordingState(
          goalMl: 2400,
          consumedMl: 250,
          entries: [tWaterModel],
        ),
      );
    });

    test('addPreset success adds a log', () async {
      when(() => mockRemoteDataSource.getWaterLogs(any())).thenAnswer((_) async => []);
      when(() => mockRemoteDataSource.getWaterGoal()).thenAnswer((_) async => 2500);
      when(() => mockRemoteDataSource.addWaterLog(
            amountMl: 250,
            preset: 'cup',
          )).thenAnswer((_) async => tWaterModel);

      cubit = WaterRecordingCubit(remoteDataSource: mockRemoteDataSource);
      await Future.delayed(Duration.zero);

      // Setup mock to return the added entry on subsequent load
      when(() => mockRemoteDataSource.getWaterLogs(any())).thenAnswer((_) async => [tWaterModel]);

      await cubit.addPreset(WaterPreset.cup);

      expect(
        cubit.state,
        WaterRecordingState(
          goalMl: 2500,
          consumedMl: 250,
          entries: [tWaterModel],
          selectedPreset: WaterPreset.cup,
        ),
      );
    });
  });
}
