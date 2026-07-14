import 'package:afia/features/explore/data/models/food_item_model.dart';

abstract class ExploreRemoteDataSource {
  Future<List<FoodItemModel>> getFoods({String? query, String? categoryEn});
  Future<void> logFood({required FoodItemModel food, required String slotType});
}
