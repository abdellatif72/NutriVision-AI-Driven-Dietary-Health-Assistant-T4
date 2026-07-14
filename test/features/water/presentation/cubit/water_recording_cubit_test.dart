import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:afia/features/water/domain/usecases/add_water_log.dart';
import 'package:afia/features/water/domain/usecases/delete_water_log.dart';
import 'package:afia/features/water/domain/usecases/get_water_goal.dart';
import 'package:afia/features/water/domain/usecases/get_water_logs.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWaterLogs extends Mock implements GetWaterLogs {}
class MockAddWaterLog extends Mock implements AddWaterLog {}
class MockDeleteWaterLog extends Mock implements DeleteWaterLog {}
class MockGetWaterGoal extends Mock implements GetWaterGoal {}

void main() {
  late WaterRecordingCubit cubit;
  late MockGetWaterLogs mockGetWaterLogs;
  late MockAddWaterLog mockAddWaterLog;
  late MockDeleteWaterLog mockDeleteWaterLog;
  late MockGetWaterGoal mockGetWaterGoal;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockGetWaterLogs = MockGetWaterLogs();
    mockAddWaterLog = MockAddWaterLog();
    mockDeleteWaterLog = MockDeleteWaterLog();
    mockGetWaterGoal = MockGetWaterGoal();
  });

  group('WaterRecordingCubit', () {
    final tDate = DateTime.now();
    final tWaterEntry = WaterEntry(
      id: '1',
      timestamp: tDate,
      amountMl: 250,
      preset: WaterPreset.cup,
    );

    test('initial state has loading status', () {
      when(() => mockGetWaterLogs(any())).thenAnswer((_) async => const Right([]));
      when(() => mockGetWaterGoal()).thenAnswer((_) async => const Right(2500));

      cubit = WaterRecordingCubit(
        getWaterLogs: mockGetWaterLogs,
        addWaterLog: mockAddWaterLog,
        deleteWaterLog: mockDeleteWaterLog,
        getWaterGoal: mockGetWaterGoal,
      );

      expect(cubit.state.isLoading, true);
    });

    test('loadWaterData success sets logs and goal', () async {
      when(() => mockGetWaterLogs(any())).thenAnswer((_) async => Right([tWaterEntry]));
      when(() => mockGetWaterGoal()).thenAnswer((_) async => const Right(2400));

      cubit = WaterRecordingCubit(
        getWaterLogs: mockGetWaterLogs,
        addWaterLog: mockAddWaterLog,
        deleteWaterLog: mockDeleteWaterLog,
        getWaterGoal: mockGetWaterGoal,
      );

      // Wait for constructor loading
      await Future.delayed(Duration.zero);

      expect(
        cubit.state,
        WaterRecordingState(
          isLoading: false,
          goalMl: 2400,
          consumedMl: 250,
          entries: [tWaterEntry],
        ),
      );
    });

    test('addPreset success adds a log', () async {
      when(() => mockGetWaterLogs(any())).thenAnswer((_) async => const Right([]));
      when(() => mockGetWaterGoal()).thenAnswer((_) async => const Right(2500));
      when(() => mockAddWaterLog(
            amountMl: 250,
            preset: 'cup',
          )).thenAnswer((_) async => Right(tWaterEntry));

      cubit = WaterRecordingCubit(
        getWaterLogs: mockGetWaterLogs,
        addWaterLog: mockAddWaterLog,
        deleteWaterLog: mockDeleteWaterLog,
        getWaterGoal: mockGetWaterGoal,
      );

      await Future.delayed(Duration.zero);

      cubit.addPreset(WaterPreset.cup);

      await Future.delayed(Duration.zero);

      expect(
        cubit.state,
        WaterRecordingState(
          isLoading: false,
          goalMl: 2500,
          consumedMl: 250,
          entries: [tWaterEntry],
          selectedPreset: WaterPreset.cup,
        ),
      );
    });
  });
}
