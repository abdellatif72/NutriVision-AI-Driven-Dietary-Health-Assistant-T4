import 'package:afia/features/water/data/datasources/water_remote_datasource.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
export 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterRecordingState extends Equatable {
  const WaterRecordingState({
    this.goalMl = 2500,
    this.consumedMl = 0,
    this.entries = const [],
    this.selectedPreset,
  });

  final int goalMl;
  final int consumedMl;
  final List<WaterEntry> entries;
  final WaterPreset? selectedPreset;

  double get progress =>
      goalMl <= 0 ? 0 : (consumedMl / goalMl).clamp(0.0, 1.0);

  WaterRecordingState copyWith({
    int? goalMl,
    int? consumedMl,
    List<WaterEntry>? entries,
    WaterPreset? selectedPreset,
    bool clearSelectedPreset = false,
  }) {
    return WaterRecordingState(
      goalMl: goalMl ?? this.goalMl,
      consumedMl: consumedMl ?? this.consumedMl,
      entries: entries ?? this.entries,
      selectedPreset: clearSelectedPreset
          ? null
          : (selectedPreset ?? this.selectedPreset),
    );
  }

  @override
  List<Object?> get props => [goalMl, consumedMl, entries, selectedPreset];
}

class WaterRecordingCubit extends Cubit<WaterRecordingState> {
  final WaterRemoteDataSource _remoteDataSource;

  WaterRecordingCubit({required WaterRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(const WaterRecordingState()) {
    loadWaterData();
  }

  Future<void> loadWaterData() async {
    try {
      final goal = await _remoteDataSource.getWaterGoal();
      final logs = await _remoteDataSource.getWaterLogs(DateTime.now());
      
      emit(WaterRecordingState(
        goalMl: goal,
        consumedMl: logs.fold<int>(0, (sum, e) => sum + e.amountMl),
        entries: logs,
      ));
    } catch (e) {
      // Keep existing state or handle error
    }
  }

  void selectPreset(WaterPreset preset) {
    emit(state.copyWith(selectedPreset: preset));
  }

  Future<void> addPreset(WaterPreset preset) async {
    if (preset == WaterPreset.custom || preset.amountMl <= 0) return;
    await _addEntry(preset.amountMl, preset);
  }

  Future<void> addAmount(int amountMl) async {
    if (amountMl <= 0) return;
    await _addEntry(amountMl, WaterPreset.custom);
  }

  Future<void> addCustomAmount(int amountMl) async {
    if (amountMl <= 0) return;
    await _addEntry(amountMl, WaterPreset.custom);
  }

  Future<void> deleteEntry(String id) async {
    try {
      await _remoteDataSource.deleteWaterLog(id);
      await loadWaterData();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _addEntry(int amountMl, WaterPreset preset) async {
    try {
      String presetStr = 'custom';
      if (preset == WaterPreset.cup) {
        presetStr = 'cup';
      } else if (preset == WaterPreset.pint) {
        presetStr = 'pint';
      }

      await _remoteDataSource.addWaterLog(
        amountMl: amountMl,
        preset: presetStr,
      );
      
      await loadWaterData();
      emit(state.copyWith(selectedPreset: preset));
    } catch (e) {
      // Handle error
    }
  }
}
