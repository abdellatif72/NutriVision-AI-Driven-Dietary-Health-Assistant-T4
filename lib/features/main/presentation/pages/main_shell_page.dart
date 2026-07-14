import 'package:afia/app/di/injection_container.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/main_shell_cubit.dart';
import 'package:afia/features/main/presentation/pages/home_page.dart';
import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:afia/features/ai/presentation/pages/chat_page.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:afia/features/main/presentation/widgets/afia_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, this.initialTab = MainTab.home});

  final MainTab initialTab;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userName = authState is AuthAuthenticated ? (authState.user.name ?? '') : '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainShellCubit()..selectTab(initialTab)),
        BlocProvider(create: (_) => sl<MealsCubit>()..loadMeals()),
        // Build HomeCubit after MealsCubit is ready, so sl() successfully retrieves it and passes it as parameter
        BlocProvider(create: (ctx) => sl<HomeCubit>(param1: userName)..loadDashboardData()),
      ],
      child: const _MainShellView(),
    );
  }
}

class _MainShellView extends StatefulWidget {
  const _MainShellView();

  @override
  State<_MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<_MainShellView> {
  List<AfiaNavItem> _buildNavItems(BuildContext context) {
    final l = AppLocalizations.of(context);
    return [
      AfiaNavItem(icon: Icons.home_rounded, label: l.translate('home')),
      AfiaNavItem(icon: Icons.restaurant_menu_rounded, label: l.translate('meals')),
      AfiaNavItem(icon: Icons.chat_bubble_outline_rounded, label: l.translate('chat')),
      AfiaNavItem(icon: Icons.more_horiz_rounded, label: l.translate('more')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainShellCubit, MainShellState>(
      builder: (context, state) {
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        // Height of the nav bar (80) + bottom safe area
        const navBarHeight = 80.0;
        final totalNavHeight = navBarHeight + bottomPadding;

        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          // No bottomNavigationBar here — we overlay it via Stack to avoid
          // Flutter painting a solid background in that slot.
          body: Stack(
            children: [
              // Pages fill the full screen, including behind the nav bar
              Positioned.fill(
                child: IndexedStack(
                  index: state.tab.indexInStack,
                  children: const [
                    HomePage(showBottomNav: false),
                    MealsPage(showBottomNav: false),
                    ChatPage(showBottomNav: false),
                    MorePage(),
                  ],
                ),
              ),
              // Nav bar overlaid at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: totalNavHeight,
                child: AfiaBottomNav(
                  items: _buildNavItems(context),
                  selectedIndex: state.tab.indexInStack,
                  onSelected: (index) {
                    final tab = MainTab.values[index];
                    context.read<MainShellCubit>().selectTab(tab);
                    if (tab == MainTab.home) {
                      context.read<HomeCubit>().loadDashboardData();
                    } else if (tab == MainTab.meals) {
                      context.read<MealsCubit>().loadMeals();
                    }
                  },
                  centerIcon: Icons.add_rounded,
                  onCenterTap: () => _showActionBottomSheet(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showActionBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
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
                Builder(
                  builder: (ctx) {
                    final isAr = Localizations.localeOf(ctx).languageCode == 'ar';
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionSheetTile(
                          icon: Icons.water_drop_rounded,
                          title: isAr ? 'تسجيل شرب الماء' : 'Log Water',
                          subtitle: isAr ? 'سجّل كمية الماء التي شربتها' : 'Record your water intake',
                          onTap: () {
                            Navigator.pop(sheetContext);
                            Navigator.pushNamed(context, RouteNames.water).then((_) {
                              if (context.mounted) {
                                context.read<HomeCubit>().loadDashboardData();
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _ActionSheetTile(
                          icon: Icons.explore_rounded,
                          title: isAr ? 'تصفح الأطعمة' : 'Explore Foods',
                          subtitle: isAr ? 'تصفح كتالوج الأطعمة وسجّلها' : 'Browse food catalog and log them',
                          onTap: () {
                            Navigator.pop(sheetContext);
                            Navigator.pushNamed(context, RouteNames.explore);
                          },
                        ),
                        const SizedBox(height: 8),
                        _ActionSheetTile(
                          iconWidget: Stack(
                            children: const [
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
                          title: isAr ? 'مسح ذكي بالذكاء الاصطناعي' : 'AI Smart Scan',
                          subtitle: isAr ? 'التقط صورة لتحليل القيم الغذائية' : 'Snap a photo for nutrition analysis',
                          onTap: () {
                            Navigator.pop(sheetContext);
                            Navigator.pushNamed(context, RouteNames.ai);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
              const Icon(
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
