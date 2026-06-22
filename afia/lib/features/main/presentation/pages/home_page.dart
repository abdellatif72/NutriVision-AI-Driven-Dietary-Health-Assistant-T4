import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/widgets/calories_ring_card.dart';
import 'package:afia/features/main/presentation/widgets/greeting_header.dart';
import 'package:afia/features/main/presentation/widgets/streak_card.dart';
import 'package:afia/features/main/presentation/widgets/todays_meals_list.dart';
import 'package:afia/features/main/presentation/widgets/water_quick_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadMockDashboard(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status != HomeStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          color: AfiaColors.scaffoldBackground,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              GreetingHeader(
                greeting: state.greeting,
                userName: state.userName,
              ),
              const SizedBox(height: 12),
              if (state.calories != null)
                CaloriesRingCard(summary: state.calories!),
              if (state.streak != null) StreakCard(summary: state.streak!),
              if (state.water != null) WaterQuickTile(summary: state.water!),
              TodaysMealsList(meals: state.meals),
            ],
          ),
        );
      },
    );
  }
}
