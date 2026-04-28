part of 'meal_search_bloc.dart';

enum MealSearchStatus { idle, loading, success, empty, failure }

class MealSearchState extends Equatable {
  const MealSearchState._({
    required this.status,
    this.results = const [],
    this.query = '',
    this.errorMessage,
  });

  const MealSearchState.idle() : this._(status: MealSearchStatus.idle);

  const MealSearchState.loading() : this._(status: MealSearchStatus.loading);

  const MealSearchState.success(List<MealSummary> results)
      : this._(status: MealSearchStatus.success, results: results);

  const MealSearchState.empty(String query)
      : this._(status: MealSearchStatus.empty, query: query);

  const MealSearchState.failure(String message)
      : this._(status: MealSearchStatus.failure, errorMessage: message);

  final MealSearchStatus status;
  final List<MealSummary> results;
  final String query;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, results, query, errorMessage];
}
