part of 'explore_bloc.dart';

enum ExploreStatus { initial, loading, success, failure }
enum LoggingStatus { initial, loading, success, failure }

class ExploreState extends Equatable {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.foods = const [],
    this.searchQuery = '',
    this.selectedCategoryEn = 'all',
    this.loggingStatus = LoggingStatus.initial,
    this.errorMessage,
  });

  final ExploreStatus status;
  final List<FoodItem> foods;
  final String searchQuery;
  final String selectedCategoryEn;
  final LoggingStatus loggingStatus;
  final String? errorMessage;

  ExploreState copyWith({
    ExploreStatus? status,
    List<FoodItem>? foods,
    String? searchQuery,
    String? selectedCategoryEn,
    LoggingStatus? loggingStatus,
    String? errorMessage,
  }) {
    return ExploreState(
      status: status ?? this.status,
      foods: foods ?? this.foods,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryEn: selectedCategoryEn ?? this.selectedCategoryEn,
      loggingStatus: loggingStatus ?? this.loggingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        foods,
        searchQuery,
        selectedCategoryEn,
        loggingStatus,
        errorMessage,
      ];
}
