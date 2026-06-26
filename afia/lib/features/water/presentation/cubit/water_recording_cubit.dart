import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum WaterPreset {
  cup(amountMl: 250, label: '250 ml', sublabel: 'cup'),
  pint(amountMl: 500, label: '500 ml', sublabel: 'pint'),
  custom(amountMl: 0, label: 'Custom', sublabel: 'amount');

  const WaterPreset({
    required this.amountMl,
    required this.label,
    required this.sublabel,
  });

  final int amountMl;
  final String label;
  final String sublabel;
}

class WaterEntry extends Equatable {
  const WaterEntry({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    required this.preset,
  });

  final String id;
  final DateTime timestamp;
  final int amountMl;
  final WaterPreset preset;

  @override
  List<Object?> get props => [id, timestamp, amountMl, preset];
}

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
  WaterRecordingCubit() : super(const WaterRecordingState()) {
    _loadMock();
  }

  void _loadMock() {
    final today = DateTime.now();
    DateTime at(int hour, int minute) =>
        DateTime(today.year, today.month, today.day, hour, minute);
    final entries = <WaterEntry>[
      WaterEntry(
        id: '1',
        timestamp: at(8, 0),
        amountMl: 250,
        preset: WaterPreset.cup,
      ),
      WaterEntry(
        id: '2',
        timestamp: at(10, 30),
        amountMl: 500,
        preset: WaterPreset.pint,
      ),
      WaterEntry(
        id: '3',
        timestamp: at(16, 15),
        amountMl: 500,
        preset: WaterPreset.pint,
      ),
      WaterEntry(
        id: '4',
        timestamp: at(15, 30),
        amountMl: 250,
        preset: WaterPreset.cup,
      ),
    ];
    emit(
      WaterRecordingState(
        goalMl: 2400,
        consumedMl: entries.fold<int>(0, (sum, e) => sum + e.amountMl),
        entries: entries,
        selectedPreset: WaterPreset.pint,
      ),
    );
  }

  void selectPreset(WaterPreset preset) {
    emit(state.copyWith(selectedPreset: preset));
  }

  void addPreset(WaterPreset preset) {
    if (preset == WaterPreset.custom || preset.amountMl <= 0) return;
    _addEntry(preset.amountMl, preset);
  }

  void addAmount(int amountMl) {
    if (amountMl <= 0) return;
    _addEntry(amountMl, WaterPreset.custom);
  }

  void addCustomAmount(int amountMl) {
    if (amountMl <= 0) return;
    _addEntry(amountMl, WaterPreset.custom);
  }

  void deleteEntry(String id) {
    final updated = state.entries.where((e) => e.id != id).toList();
    emit(
      state.copyWith(
        entries: updated,
        consumedMl: updated.fold<int>(0, (sum, e) => sum + e.amountMl),
      ),
    );
  }

  void _addEntry(int amountMl, WaterPreset preset) {
    final entry = WaterEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      amountMl: amountMl,
      preset: preset,
    );
    final updated = [...state.entries, entry];
    emit(
      state.copyWith(
        entries: updated,
        consumedMl: state.consumedMl + amountMl,
        selectedPreset: preset,
      ),
    );
  }
}
