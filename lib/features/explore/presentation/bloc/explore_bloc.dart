import 'dart:async';
import 'package:afia/features/explore/domain/entities/food_item.dart';
import 'package:afia/features/explore/domain/usecases/get_foods.dart';
import 'package:afia/features/explore/domain/usecases/log_food.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

part 'explore_event.dart';
part 'explore_state.dart';

const _debounceDuration = Duration(milliseconds: 300);

EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) =>
      restartable<E>().call(events.debounce(duration), mapper);
}

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc({
    required GetFoods getFoods,
    required LogFood logFood,
  })  : _getFoods = getFoods,
        _logFood = logFood,
        super(const ExploreState()) {
    on<LoadCatalog>(_onLoadCatalog);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: _debounceRestartable(_debounceDuration),
    );
    on<CategoryChanged>(_onCategoryChanged);
    on<LogFoodItem>(_onLogFoodItem);
  }

  final GetFoods _getFoods;
  final LogFood _logFood;

  Future<void> _onLoadCatalog(LoadCatalog event, EmitState emit) async {
    emit(state.copyWith(status: ExploreStatus.loading));
    try {
      final foods = await _getFoods(
        query: state.searchQuery,
        categoryEn: state.selectedCategoryEn,
      );
      emit(state.copyWith(status: ExploreStatus.success, foods: foods));
    } catch (e) {
      emit(state.copyWith(
        status: ExploreStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, EmitState emit) async {
    emit(state.copyWith(searchQuery: event.query, status: ExploreStatus.loading));
    try {
      final foods = await _getFoods(
        query: event.query,
        categoryEn: state.selectedCategoryEn,
      );
      emit(state.copyWith(status: ExploreStatus.success, foods: foods));
    } catch (e) {
      emit(state.copyWith(
        status: ExploreStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCategoryChanged(CategoryChanged event, EmitState emit) async {
    emit(state.copyWith(selectedCategoryEn: event.categoryEn, status: ExploreStatus.loading));
    try {
      final foods = await _getFoods(
        query: state.searchQuery,
        categoryEn: event.categoryEn,
      );
      emit(state.copyWith(status: ExploreStatus.success, foods: foods));
    } catch (e) {
      emit(state.copyWith(
        status: ExploreStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogFoodItem(LogFoodItem event, EmitState emit) async {
    emit(state.copyWith(loggingStatus: LoggingStatus.loading));
    try {
      await _logFood(food: event.food, slotType: event.slotType);
      emit(state.copyWith(loggingStatus: LoggingStatus.success));
      // Reset logging status back to initial
      emit(state.copyWith(loggingStatus: LoggingStatus.initial));
    } catch (e) {
      emit(state.copyWith(
        loggingStatus: LoggingStatus.failure,
        errorMessage: e.toString(),
      ));
      // Reset logging status back to initial
      emit(state.copyWith(loggingStatus: LoggingStatus.initial));
    }
  }
}

typedef EmitState = Emitter<ExploreState>;
