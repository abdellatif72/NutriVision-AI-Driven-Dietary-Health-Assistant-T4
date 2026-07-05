import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/widgets/afia_bottom_nav.dart';
import 'package:afia/features/main/presentation/widgets/calories_progress_card.dart';
import 'package:afia/features/main/presentation/widgets/daily_progress_card.dart';
import 'package:afia/features/main/presentation/widgets/greeting_header.dart';
import 'package:afia/features/main/presentation/widgets/metric_card.dart';
import 'package:afia/features/main/presentation/widgets/todays_meals_list.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ActionSheetTile extends StatelessWidget {
  const _ActionSheetTile({
    this.icon,
    this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : assert(
         icon != null || iconWidget != null,
         'Either icon or iconWidget must be provided',
       );

  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child:
                      iconWidget ??
                      Icon(icon, size: 28, color: AfiaColors.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AfiaColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedNavIndex = 0;

  static const _navItems = [
    AfiaNavItem(icon: Icons.home_rounded, label: 'Home'),
    AfiaNavItem(icon: Icons.restaurant_menu_rounded, label: 'Meals'),
    AfiaNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
    AfiaNavItem(icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  void _showActionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AfiaColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                _ActionSheetTile(
                  icon: Icons.water_drop_rounded,
                  title: 'Log Water',
                  subtitle: 'Record your water intake',
                  onTap: () => _onLogWaterTap(context),
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  icon: Icons.restaurant_rounded,
                  title: 'Log Meal',
                  subtitle: 'Add a meal to your diary',
                  onTap: _onLogMealTap,
                ),
                const SizedBox(height: 8),
                _ActionSheetTile(
                  iconWidget: Stack(
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        size: 28,
                        color: AfiaColors.primary,
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: AfiaColors.primary,
                        ),
                      ),
                    ],
                  ),
                  title: 'AI Smart Scan',
                  subtitle: 'Snap a photo for nutrition analysis',
                  onTap: _onAIScanTap,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onLogWaterTap(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, RouteNames.water);
  }

  void _onLogMealTap() {}

  void _onAIScanTap() {}

  String _formatNumber(int number) {
    if (number >= 1000) {
      final thousands = number ~/ 1000;
      final remainder = number % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status != HomeStatus.success) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AfiaColors.primary),
            ),
          );
        }

        final stepsText = state.steps != null
            ? _formatNumber(state.steps!)
            : '0';
        final stepsGoalText = state.stepsGoal != null
            ? '/${_formatNumber(state.stepsGoal!)}'
            : '/10,000';

        final waterText = state.water != null
            ? state.water!.consumedLiters.toStringAsFixed(1)
            : '0.0';
        final waterGoalText = state.water != null
            ? '/${state.water!.goalLiters.toStringAsFixed(1)} L'
            : '/2.5 L';

        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 18),
              physics: const BouncingScrollPhysics(),
              children: [
                GreetingHeader(
                  greeting: state.greeting,
                  userName: state.userName,
                ),
                const DailyProgressCard(
                  percent: 0.78,
                  description: "Great job! You're\non track today.",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          kind: AfiaMetricKind.steps,
                          icon: Icons.directions_walk_rounded,
                          title: 'Steps',
                          value: stepsText,
                          subtext: stepsGoalText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricCard(
                          kind: AfiaMetricKind.water,
                          icon: Icons.water_drop_rounded,
                          title: 'Water',
                          value: waterText,
                          valueUnit: 'L',
                          subtext: waterGoalText,
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteNames.water,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricCard(
                          kind: AfiaMetricKind.heartRate,
                          icon: Icons.favorite_rounded,
                          title: 'Heart Rate',
                          value: state.heartRate != null
                              ? '${state.heartRate}'
                              : '72',
                          valueUnit: 'bpm',
                          subtext: state.heartRateStatus ?? 'Resting',
                        ),
                      ),
                    ],
                  ),
                ),
                CaloriesProgressCard(
                  consumed: state.calories?.consumed ?? 1420,
                  goal: state.calories?.goal ?? 2000,
                ),
                TodaysMealsList(meals: state.meals),
              ],
            ),
          ),
          bottomNavigationBar: AfiaBottomNav(
            items: _navItems,
            selectedIndex: _selectedNavIndex,
            onSelected: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, RouteNames.meals);
                return;
              }
              if (index == 2) {
                Navigator.pushNamed(context, RouteNames.ai);
                return;
              }
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePage()),
                );
                return;
              }
              setState(() => _selectedNavIndex = index);
            },
            centerIcon: Icons.add_rounded,
            onCenterTap: () => _showActionBottomSheet(context),
          ),
        );
      },
    );
  }
}
