import 'package:afia/app/theme/app_colors.dart';
import 'package:afia/features/main/presentation/cubit/main_shell_cubit.dart';
import 'package:afia/features/main/presentation/pages/home_page.dart';
import 'package:afia/features/main/presentation/pages/progress_page.dart';
import 'package:afia/features/main/presentation/widgets/quick_add_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainShellCubit(),
      child: const _MainShellView(),
    );
  }
}

class _MainShellView extends StatelessWidget {
  const _MainShellView();

  static const _tabs = <Widget>[
    HomePage(),
    ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainShellCubit, MainShellState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: state.tab.indexInStack,
              children: _tabs,
            ),
          ),
          bottomNavigationBar: _MainBottomNav(activeTab: state.tab),
          floatingActionButton: const _QuickAddButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}

class _MainBottomNav extends StatelessWidget {
  const _MainBottomNav({required this.activeTab});

  final MainTab activeTab;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainShellCubit>();
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: activeTab == MainTab.home,
            onTap: () => cubit.selectTab(MainTab.home),
          ),
          _NavItem(
            icon: Icons.show_chart,
            label: 'Progress',
            selected: activeTab == MainTab.progress,
            onTap: () => cubit.selectTab(MainTab.progress),
          ),
          const SizedBox(width: 56),
          _NavItem(
            icon: Icons.search,
            label: 'Explore',
            selected: false,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Account',
            selected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showQuickAddSheet(context),
      backgroundColor: AppColors.primary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
