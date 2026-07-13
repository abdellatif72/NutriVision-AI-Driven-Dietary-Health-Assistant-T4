import 'package:afia/features/explore/domain/entities/food_item.dart';
import 'package:afia/features/explore/domain/repositories/explore_repository.dart';

class GetFoods {
  const GetFoods(this.repository);

  final ExploreRepository repository;

  Future<List<FoodItem>> call({String? query, String? categoryEn}) {
    return repository.getFoods(query: query, categoryEn: categoryEn);
  }
}
