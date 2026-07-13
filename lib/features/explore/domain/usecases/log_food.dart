import 'package:afia/features/explore/domain/entities/food_item.dart';
import 'package:afia/features/explore/domain/repositories/explore_repository.dart';

class LogFood {
  const LogFood(this.repository);

  final ExploreRepository repository;

  Future<void> call({required FoodItem food, required String slotType}) {
    return repository.logFood(food: food, slotType: slotType);
  }
}
