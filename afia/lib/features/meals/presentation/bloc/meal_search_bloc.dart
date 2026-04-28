import 'dart:async';

import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

part 'meal_search_event.dart';
part 'meal_search_state.dart';

const _debounceDuration = Duration(milliseconds: 300);

EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) =>
      restartable<E>().call(events.debounce(duration), mapper);
}

class MealSearchBloc extends Bloc<MealSearchEvent, MealSearchState> {
  MealSearchBloc() : super(const MealSearchState.idle()) {
    on<QueryChanged>(_onQueryChanged, transformer: _debounceRestartable(_debounceDuration));
    on<ResultSelected>(_onResultSelected);
  }

  static const _catalog = <MealSummary>[
    MealSummary(
      id: 'koshary',
      name: 'Koshary',
      emoji: '🍚',
      servingLabel: '1 plate · 350 g',
      calories: 420,
    ),
    MealSummary(
      id: 'fava-beans',
      name: 'Fava beans',
      emoji: '🫘',
      servingLabel: '1 bowl · 200 g',
      calories: 180,
    ),
    MealSummary(
      id: 'shawarma',
      name: 'Shawarma',
      emoji: '🌯',
      servingLabel: '1 wrap · 250 g',
      calories: 520,
    ),
    MealSummary(
      id: 'falafel',
      name: 'Falafel',
      emoji: '🧆',
      servingLabel: '5 pieces · 150 g',
      calories: 333,
    ),
    MealSummary(
      id: 'molokhia',
      name: 'Molokhia',
      emoji: '🥬',
      servingLabel: '1 bowl · 250 g',
      calories: 210,
    ),
    MealSummary(
      id: 'grilled-chicken',
      name: 'Grilled chicken',
      emoji: '🍗',
      servingLabel: '1 breast · 180 g',
      calories: 295,
    ),
    MealSummary(
      id: 'mahshi',
      name: 'Mahshi',
      emoji: '🍆',
      servingLabel: '6 pieces · 300 g',
      calories: 380,
    ),
    MealSummary(
      id: 'tameya',
      name: 'Ta\'ameya sandwich',
      emoji: '🥙',
      servingLabel: '1 sandwich',
      calories: 260,
    ),
  ];

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<MealSearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const MealSearchState.idle());
      return;
    }

    emit(const MealSearchState.loading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final lower = query.toLowerCase();
      final results = _catalog
          .where((m) => m.name.toLowerCase().contains(lower))
          .toList();
      if (results.isEmpty) {
        emit(MealSearchState.empty(query));
      } else {
        emit(MealSearchState.success(results));
      }
    } catch (_) {
      emit(const MealSearchState.failure('Could not search meals.'));
    }
  }

  void _onResultSelected(
    ResultSelected event,
    Emitter<MealSearchState> emit,
  ) {
    // Selection is handled by the page (navigation); state untouched.
  }
}
