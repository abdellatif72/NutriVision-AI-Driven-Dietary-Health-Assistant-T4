import 'package:afia/app/di/injection_container.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/pages/meal_category_detail_page.dart';
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
  const HomePage({super.key, this.showBottomNav = true});
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    // Read the real user name from the global AuthBloc
    final authState = context.read<AuthBloc>().state;
    final userName = authState is AuthAuthenticated ? (authState.user.name ?? '') : '';
    
    try {
      context.read<HomeCubit>();
      return _HomeView(showBottomNav: showBottomNav);
    } catch (_) {
      return BlocProvider(
        create: (_) => sl<HomeCubit>(param1: userName)..loadDashboardData(),
        child: _HomeView(showBottomNav: showBottomNav),
      );
    }
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({this.showBottomNav = true});
  final bool showBottomNav;

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

        final waterText = state.water != null
            ? state.water!.consumedLiters.toStringAsFixed(1)
            : '0.0';
        final waterGoalText = state.water != null
            ? '/${state.water!.goalLiters.toStringAsFixed(1)} L'
            : '/2.5 L';

        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        final waterTitle = isAr ? 'الماء' : 'Water';

        // Bottom padding = nav bar height (80) + device safe-area so content
        // isn't hidden behind the Stack-overlaid bottom navigation bar.
        final navBottomPadding = 80.0 + MediaQuery.paddingOf(context).bottom;

        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          body: SafeArea(
            bottom: false, // we manage bottom inset manually via padding below
            child: ListView(
              padding: EdgeInsets.only(bottom: navBottomPadding),
              physics: const BouncingScrollPhysics(),
              children: [
                GreetingHeader(
                  greeting: isAr ? 'لنبدأ يوماً رائعاً معاً!' : state.greeting,
                  userName: state.userName,
                ),
                Builder(builder: (context) {
                  final caloriePercent = (state.calories?.percent ?? 0.0).clamp(0.0, 1.0);
                  final String progressDesc;
                  if (isAr) {
                    if (caloriePercent >= 1.0) {
                      progressDesc = 'لقد وصلت إلى هدفك اليومي! 🎉';
                    } else if (caloriePercent >= 0.75) {
                      progressDesc = 'رائع! أنت\nعلى المسار الصحيح اليوم.';
                    } else if (caloriePercent >= 0.5) {
                      progressDesc = 'تقدم جيد!\nأنت في منتصف الطريق.';
                    } else {
                      progressDesc = 'لنبدأ! أنت\nفي بداية رحلتك اليوم.';
                    }
                  } else {
                    if (caloriePercent >= 1.0) {
                      progressDesc = "You've reached your\ndaily goal! 🎉";
                    } else if (caloriePercent >= 0.75) {
                      progressDesc = "Great job! You're\nalmost there.";
                    } else if (caloriePercent >= 0.5) {
                      progressDesc = "Good progress!\nYou're halfway there.";
                    } else {
                      progressDesc = "Let's get going — you're\njust getting started.";
                    }
                  }
                  return DailyProgressCard(
                    percent: caloriePercent,
                    description: progressDesc,
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: MetricCard(
                    kind: AfiaMetricKind.water,
                    icon: Icons.water_drop_rounded,
                    title: waterTitle,
                    value: waterText,
                    valueUnit: isAr ? 'لتر' : 'L',
                    subtext: isAr ? '/٢.٥ لتر' : waterGoalText,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.water,
                    ),
                  ),
                ),
                CaloriesProgressCard(
                  consumed: state.calories?.consumed ?? 1420,
                  goal: state.calories?.goal ?? 2000,
                ),
                TodaysMealsList(meals: state.meals, onMealTap: (meal) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealCategoryDetailPage(mealEntry: meal),
                    ),
                  );
                }),
              ],
            ),
          ),
          bottomNavigationBar: widget.showBottomNav
              ? AfiaBottomNav(
                  items: _navItems,
                  selectedIndex: _selectedNavIndex,
                  onSelected: (index) {
                    if (index == 1) {
                      Navigator.pushNamed(context, RouteNames.meals);
                      return;
                    }
                    if (index == 2) {
                      Navigator.pushNamed(context, RouteNames.chat);
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
                )
              : null,
        );
      },
    );
  }
}
