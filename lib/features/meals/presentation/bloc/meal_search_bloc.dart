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
      nameAr: 'كشري',
      emoji: '🍚',
      servingLabel: '1 plate · 350 g',
      servingLabelAr: 'طبق واحد · ٣٥٠ غرام',
      calories: 420,
      tags: ['arabic', 'recent'],
    ),
    MealSummary(
      id: 'fava-beans',
      name: 'Fava beans',
      nameAr: 'فول مدمس',
      emoji: '🫘',
      servingLabel: '1 bowl · 200 g',
      servingLabelAr: 'طبق واحد · ٢٠٠ غرام',
      calories: 180,
      tags: ['arabic', 'healthy', 'recent'],
    ),
    MealSummary(
      id: 'shawarma',
      name: 'Shawarma',
      nameAr: 'شاورما',
      emoji: '🌯',
      servingLabel: '1 wrap · 250 g',
      servingLabelAr: 'سندويش واحد · ٢٥٠ غرام',
      calories: 520,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'falafel',
      name: 'Falafel',
      nameAr: 'فلافل',
      emoji: '🧆',
      servingLabel: '5 pieces · 150 g',
      servingLabelAr: '٥ حبات · ١٥٠ غرام',
      calories: 333,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'molokhia',
      name: 'Molokhia',
      nameAr: 'ملوخية',
      emoji: '🥬',
      servingLabel: '1 bowl · 250 g',
      servingLabelAr: 'طبق واحد · ٢٥٠ غرام',
      calories: 210,
      tags: ['arabic', 'healthy'],
    ),
    MealSummary(
      id: 'grilled-chicken',
      name: 'Grilled chicken',
      nameAr: 'دجاج مشوي',
      emoji: '🍗',
      servingLabel: '1 breast · 180 g',
      servingLabelAr: 'صدر دجاج · ١٨٠ غرام',
      calories: 295,
      tags: ['western', 'healthy', 'recent'],
    ),
    MealSummary(
      id: 'mahshi',
      name: 'Mahshi',
      nameAr: 'محشي',
      emoji: '🍆',
      servingLabel: '6 pieces · 300 g',
      servingLabelAr: '٦ حبات · ٣٠٠ غرام',
      calories: 380,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'tameya',
      name: 'Ta\'ameya sandwich',
      nameAr: 'سندويش طعمية',
      emoji: '🥙',
      servingLabel: '1 sandwich',
      servingLabelAr: 'سندويش واحد',
      calories: 260,
      tags: ['arabic'],
    ),
    MealSummary(
      id: 'caesar-salad',
      name: 'Caesar Salad',
      nameAr: 'سلطة سيزر',
      emoji: '🥗',
      servingLabel: '1 bowl · 250 g',
      servingLabelAr: 'طبق واحد · ٢٥٠ غرام',
      calories: 250,
      tags: ['western', 'healthy'],
    ),
    MealSummary(
      id: 'beef-burger',
      name: 'Beef Burger',
      nameAr: 'برجر لحم البقر',
      emoji: '🍔',
      servingLabel: '1 burger · 220 g',
      servingLabelAr: 'برجر واحد · ٢٢٠ غرام',
      calories: 580,
      tags: ['western'],
    ),
    MealSummary(
      id: 'pizza-slice',
      name: 'Pizza Slice',
      nameAr: 'شريحة بيتزا',
      emoji: '🍕',
      servingLabel: '1 slice · 120 g',
      servingLabelAr: 'شريحة واحدة · ١٢٠ غرام',
      calories: 285,
      tags: ['western', 'recent'],
    ),
    MealSummary(
      id: 'salmon-asparagus',
      name: 'Salmon & Asparagus',
      nameAr: 'سلمون مع هليون',
      emoji: '🐟',
      servingLabel: '1 plate · 200 g',
      servingLabelAr: 'طبق واحد · ٢٠٠ غرام',
      calories: 380,
      tags: ['western', 'healthy'],
    ),
    MealSummary(
      id: 'oatmeal',
      name: 'Oatmeal',
      nameAr: 'شوفان بالتوت البري',
      emoji: '🥣',
      servingLabel: '1 bowl · 150 g',
      servingLabelAr: 'طبق واحد · ١٥٠ غرام',
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
