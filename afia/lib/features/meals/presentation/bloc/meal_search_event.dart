part of 'meal_search_bloc.dart';

sealed class MealSearchEvent extends Equatable {
  const MealSearchEvent();

  @override
  List<Object?> get props => [];
}

class QueryChanged extends MealSearchEvent {
  const QueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ResultSelected extends MealSearchEvent {
  const ResultSelected(this.meal);

  final MealSummary meal;

  @override
  List<Object?> get props => [meal];
}
