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
  MealSearchBloc()
      : super(const MealSearchState(
          status: MealSearchStatus.success,
          results: _catalog,
        )) {
    on<QueryChanged>(_onQueryChanged, transformer: _debounceRestartable(_debounceDuration));
    on<FilterTagChanged>(_onFilterTagChanged);
    on<ResultSelected>(_onResultSelected);
  }

  static const _catalog = <MealSummary>[
    MealSummary(
      id: 'koshary',
      name: 'Koshary',
      emoji: '🍚',
      servingLabel: '1 plate · 350 g',
      calories: 420,
      tags: ['arabic', 'recent'],
    ),
    MealSummary(
      id: 'fava-beans',
      name: 'Fava beans',
      emoji: '🫘',
      servingLabel: '1 bowl · 200 g',
      calories: 180,
      tags: ['arabic', 'healthy', 'recent'],
    ),
    MealSummary(
      id: 'shawarma',
      name: 'Shawarma',
      emoji: '🌯',
      servingLabel: '1 wrap · 250 g',
      calories: 520,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'falafel',
      name: 'Falafel',
      emoji: '🧆',
      servingLabel: '5 pieces · 150 g',
      calories: 333,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'molokhia',
      name: 'Molokhia',
      emoji: '🥬',
      servingLabel: '1 bowl · 250 g',
      calories: 210,
      tags: ['arabic', 'healthy'],
    ),
    MealSummary(
      id: 'grilled-chicken',
      name: 'Grilled chicken',
      emoji: '🍗',
      servingLabel: '1 breast · 180 g',
      calories: 295,
      tags: ['western', 'healthy', 'recent'],
    ),
    MealSummary(
      id: 'mahshi',
      name: 'Mahshi',
      emoji: '🍆',
      servingLabel: '6 pieces · 300 g',
      calories: 380,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'tameya',
      name: 'Ta\'ameya sandwich',
      emoji: '🥙',
      servingLabel: '1 sandwich',
      calories: 260,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'caesar-salad',
      name: 'Caesar Salad',
      emoji: '🥗',
      servingLabel: '1 bowl · 250 g',
      calories: 250,
      tags: ['western', 'healthy'],
    ),
    MealSummary(
      id: 'beef-burger',
      name: 'Beef Burger',
      emoji: '🍔',
      servingLabel: '1 burger · 220 g',
      calories: 580,
      tags: ['western'],
    ),
    MealSummary(
      id: 'pizza-slice',
      name: 'Pizza Slice',
      emoji: '🍕',
      servingLabel: '1 slice · 120 g',
      calories: 285,
      tags: ['western', 'recent'],
    ),
    MealSummary(
      id: 'salmon-asparagus',
      name: 'Salmon & Asparagus',
      emoji: '🐟',
      servingLabel: '1 plate · 200 g',
      calories: 380,
      tags: ['western', 'healthy'],
    ),
    MealSummary(
      id: 'oatmeal',
      name: 'Oatmeal',
      emoji: '🥣',
      servingLabel: '1 bowl · 150 g',
      calories: 150,
      tags: ['western', 'healthy', 'recent'],
    ),
  ];

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<MealSearchState> emit,
  ) async {
    emit(state.copyWith(status: MealSearchStatus.loading, query: event.query));
    // Simulate delay for debouncing
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _performSearch(event.query, state.selectedTag, emit);
  }

  void _onFilterTagChanged(
    FilterTagChanged event,
    Emitter<MealSearchState> emit,
  ) {
    emit(state.copyWith(status: MealSearchStatus.loading, selectedTag: event.tag));
    _performSearch(state.query, event.tag, emit);
  }

  void _performSearch(
    String query,
    String tag,
    Emitter<MealSearchState> emit,
  ) {
    final cleanQuery = query.trim().toLowerCase();

    final filtered = _catalog.where((meal) {
      if (tag != 'all') {
        if (!meal.tags.contains(tag)) return false;
      }
      if (cleanQuery.isNotEmpty) {
        if (!meal.name.toLowerCase().contains(cleanQuery)) return false;
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      emit(state.copyWith(
        status: MealSearchStatus.empty,
        results: const [],
      ));
    } else {
      emit(state.copyWith(
        status: MealSearchStatus.success,
        results: filtered,
      ));
    }
  }

  void _onResultSelected(
    ResultSelected event,
    Emitter<MealSearchState> emit,
  ) {
    // Handled by navigator pop.
  }
}
