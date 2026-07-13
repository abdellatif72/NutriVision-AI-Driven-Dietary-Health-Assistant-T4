part of 'explore_bloc.dart';

sealed class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class LoadCatalog extends ExploreEvent {
  const LoadCatalog();
}

class SearchQueryChanged extends ExploreEvent {
  const SearchQueryChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class CategoryChanged extends ExploreEvent {
  const CategoryChanged(this.categoryEn);
  final String categoryEn;

  @override
  List<Object?> get props => [categoryEn];
}

class LogFoodItem extends ExploreEvent {
  const LogFoodItem({required this.food, required this.slotType});
  final FoodItem food;
  final String slotType;

  @override
  List<Object?> get props => [food, slotType];
}
