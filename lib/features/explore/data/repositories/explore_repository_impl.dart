import 'package:afia/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:afia/features/explore/data/models/food_item_model.dart';
import 'package:afia/features/explore/domain/entities/food_item.dart';
import 'package:afia/features/explore/domain/repositories/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  const ExploreRepositoryImpl({required this.remoteDataSource});

  final ExploreRemoteDataSource remoteDataSource;

  @override
  Future<List<FoodItem>> getFoods({String? query, String? categoryEn}) async {
    return remoteDataSource.getFoods(query: query, categoryEn: categoryEn);
  }

  @override
  Future<void> logFood({required FoodItem food, required String slotType}) async {
    final model = FoodItemModel(
      id: food.id,
      nameEn: food.nameEn,
      nameAr: food.nameAr,
      emoji: food.emoji,
      categoryAr: food.categoryAr,
      categoryEn: food.categoryEn,
      servingSizeG: food.servingSizeG,
      servingLabelAr: food.servingLabelAr,
      servingLabelEn: food.servingLabelEn,
      calories: food.calories,
      proteinG: food.proteinG,
      carbsG: food.carbsG,
      fatG: food.fatG,
      fiberG: food.fiberG,
      tags: food.tags,
    );
    return remoteDataSource.logFood(food: model, slotType: slotType);
  }
}
