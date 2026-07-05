import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/bloc/meal_search_bloc.dart';
import 'package:afia/features/meals/presentation/widgets/meal_search_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealSearchPage extends StatelessWidget {
  const MealSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealSearchBloc(),
      child: const _MealSearchView(),
    );
  }
}

class _MealSearchView extends StatefulWidget {
  const _MealSearchView();

  @override
  State<_MealSearchView> createState() => _MealSearchViewState();
}

class _MealSearchViewState extends State<_MealSearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelected(MealSummary meal) {
    context.read<MealSearchBloc>().add(ResultSelected(meal));
    Navigator.of(context).pop(meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AfiaColors.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AfiaColors.textPrimary),
        ),
        title: const Text(
          'Add a meal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AfiaColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) =>
                  context.read<MealSearchBloc>().add(QueryChanged(value)),
              decoration: InputDecoration(
                hintText: 'Search for a meal... e.g., koshari, fava beans',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: AfiaColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AfiaColors.textSecondary,
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (_, value, _) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AfiaColors.textSecondary,
                      ),
                      onPressed: () {
                        _controller.clear();
                        context.read<MealSearchBloc>().add(const QueryChanged(''));
                      },
                    );
                  },
                ),
                filled: true,
                fillColor: AfiaColors.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AfiaColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AfiaColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AfiaColors.primary),
                ),
              ),
            ),
          ),

          // Filters row
          BlocBuilder<MealSearchBloc, MealSearchState>(
            builder: (context, state) {
              const tags = [
                ('all', 'All'),
                ('arabic', 'Arabic 🇪🇬'),
                ('western', 'Western 🍔'),
                ('healthy', 'Healthy 🥗'),
                ('recent', 'Recent ⏱️'),
              ];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: tags.map((t) {
                    final isSelected = state.selectedTag == t.$1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t.$2),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<MealSearchBloc>().add(FilterTagChanged(t.$1));
                          }
                        },
                        selectedColor: AfiaColors.primary,
                        backgroundColor: AfiaColors.surface,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AfiaColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : AfiaColors.divider,
                          ),
                        ),
                        elevation: 0,
                        pressElevation: 0,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          // Search results
          Expanded(
            child: BlocBuilder<MealSearchBloc, MealSearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case MealSearchStatus.idle:
                    return const _CenteredHint(
                      icon: Icons.restaurant_menu_rounded,
                      text: 'Search for a meal to log it.',
                    );
                  case MealSearchStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AfiaColors.primary,
                        strokeWidth: 2.4,
                      ),
                    );
                  case MealSearchStatus.empty:
                    return _CenteredHint(
                      icon: Icons.search_off_rounded,
                      text: 'No meals found in this category matching "${state.query}".',
                    );
                  case MealSearchStatus.failure:
                    return _CenteredHint(
                      icon: Icons.error_outline_rounded,
                      text: state.errorMessage ?? 'Something went wrong.',
                    );
                  case MealSearchStatus.success:
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: state.results.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        color: AfiaColors.divider,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (_, i) {
                        final meal = state.results[i];
                        return MealSearchTile(
                          meal: meal,
                          onTap: () => _onSelected(meal),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CenteredHint extends StatelessWidget {
  const _CenteredHint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: AfiaColors.textSecondary),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AfiaColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
