import 'package:afia/features/water/data/models/water_entry_model.dart';

abstract class WaterRemoteDataSource {
  Future<List<WaterEntryModel>> getWaterLogs(DateTime date);
  Future<WaterEntryModel> addWaterLog({
    required int amountMl,
    required String preset,
  });
  Future<void> deleteWaterLog(String id);
  Future<int> getWaterGoal();
}
