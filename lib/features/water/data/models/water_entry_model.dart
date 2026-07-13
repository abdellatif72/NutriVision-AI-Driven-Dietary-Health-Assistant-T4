import 'package:afia/features/water/domain/entities/water_entry.dart';

class WaterEntryModel extends WaterEntry {
  const WaterEntryModel({
    required super.id,
    required super.timestamp,
    required super.amountMl,
    required super.preset,
  });

  factory WaterEntryModel.fromJson(Map<String, dynamic> json) {
    final presetStr = json['preset'] as String? ?? 'custom';
    final WaterPreset preset;
    
    switch (presetStr) {
      case 'cup':
        preset = WaterPreset.cup;
        break;
      case 'pint':
        preset = WaterPreset.pint;
        break;
      case 'custom':
      default:
        preset = WaterPreset.custom;
        break;
    }

    return WaterEntryModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['logged_at'] as String).toLocal(),
      amountMl: json['amount_ml'] as int,
      preset: preset,
    );
  }

  Map<String, dynamic> toJson(String userId) {
    String presetStr = 'custom';
    if (preset == WaterPreset.cup) {
      presetStr = 'cup';
    } else if (preset == WaterPreset.pint) {
      presetStr = 'pint';
    }

    return {
      'id': id,
      'user_id': userId,
      'amount_ml': amountMl,
      'preset': presetStr,
      'logged_at': timestamp.toUtc().toIso8601String(),
    };
  }

  factory WaterEntryModel.fromEntity(WaterEntry entity) {
    return WaterEntryModel(
      id: entity.id,
      timestamp: entity.timestamp,
      amountMl: entity.amountMl,
      preset: entity.preset,
    );
  }
}
