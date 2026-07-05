part of 'meal_search_bloc.dart';

enum MealSearchStatus { idle, loading, success, empty, failure }

class MealSearchState extends Equatable {
  const MealSearchState({
    required this.status,
    this.results = const [],
    this.query = '',
    this.selectedTag = 'all',
    this.errorMessage,
  });

  const MealSearchState.idle() : this(status: MealSearchStatus.idle);

  const MealSearchState.loading({
    String query = '',
    String selectedTag = 'all',
  }) : this(status: MealSearchStatus.loading, query: query, selectedTag: selectedTag);

  const MealSearchState.success(List<MealSummary> results, {
    String query = '',
    String selectedTag = 'all',
  }) : this(status: MealSearchStatus.success, results: results, query: query, selectedTag: selectedTag);

  const MealSearchState.empty(String query, {
    String selectedTag = 'all',
  }) : this(status: MealSearchStatus.empty, query: query, selectedTag: selectedTag);

  const MealSearchState.failure(String message, {
    String query = '',
    String selectedTag = 'all',
  }) : this(status: MealSearchStatus.failure, errorMessage: message, query: query, selectedTag: selectedTag);

  final MealSearchStatus status;
  final List<MealSummary> results;
  final String query;
  final String selectedTag;
  final String? errorMessage;

  MealSearchState copyWith({
    MealSearchStatus? status,
    List<MealSummary>? results,
    String? query,
    String? selectedTag,
    String? errorMessage,
  }) {
    return MealSearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      selectedTag: selectedTag ?? this.selectedTag,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, query, selectedTag, errorMessage];
}
