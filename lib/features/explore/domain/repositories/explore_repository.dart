import 'package:afia/features/explore/domain/entities/food_item.dart';

abstract class ExploreRepository {
  Future<List<FoodItem>> getFoods({String? query, String? categoryEn});
  Future<void> logFood({required FoodItem food, required String slotType});
}
