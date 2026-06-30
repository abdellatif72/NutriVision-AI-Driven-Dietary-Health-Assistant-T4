import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({super.key});

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  final List<String> _selectedGoals = [];

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required Color iconBackground,
    required IconData icon,
    required String goalKey,
    bool selected = false,
    bool popular = false,
  }) {
    return GestureDetector(
      onTap: () => _toggleGoal(goalKey),
      child: Container(
        height: 178,
        decoration: BoxDecoration(
          color: selected ? AfiaColors.primary.withOpacity(0.08) : AfiaColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: selected ? AfiaColors.primary : AfiaColors.divider,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AfiaSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: AfiaColors.primary, size: 28),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: AfiaTypography.cardTitle.copyWith(
                      fontSize: 18,
                      color: selected ? AfiaColors.primary : AfiaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AfiaSpacing.sm),
                  Text(
                    subtitle,
                    style: AfiaTypography.body.copyWith(
                      color: AfiaColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AfiaColors.primary : AfiaColors.surface,
                  border: Border.all(
                    color: selected ? AfiaColors.primary : AfiaColors.primary.withOpacity(0.24),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 14, color: AfiaColors.onPrimary)
                    : null,
              ),
            ),
            if (popular)
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AfiaSpacing.md,
                    vertical: AfiaSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AfiaColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Popular',
                    style: AfiaTypography.body.copyWith(
                      color: AfiaColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AfiaSpacing.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AfiaSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AfiaColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: AfiaSpacing.sm),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AfiaColors.primary.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AfiaSpacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AfiaSpacing.lg, vertical: AfiaSpacing.sm),
                        decoration: BoxDecoration(
                          color: AfiaColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Step 2 of 2',
                          style: AfiaTypography.body.copyWith(
                            color: AfiaColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xl),
                    Text(
                      'What\'s your goal?',
                      style: AfiaTypography.statValue.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: AfiaSpacing.sm),
                    Text(
                      'We\'ll tailor your plan to what matters most to you.',
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // If the available width is narrow (mobile), show a single column
                        // otherwise show two columns. This prevents horizontal overflow
                        // that caused Flutter's yellow/black overflow indicator.
                        final available = constraints.maxWidth;
                        final columns = available < 420 ? 1 : 2;
                        final totalSpacing = (columns - 1) * AfiaSpacing.lg;
                        final cardWidth = (available - totalSpacing) / columns;

                        return Wrap(
                          runSpacing: AfiaSpacing.lg,
                          spacing: AfiaSpacing.lg,
                          children: [
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: 'Improve Nutrition',
                                subtitle: 'Eat healthier every day',
                                iconBackground: AfiaColors.primary.withOpacity(0.16),
                                icon: Icons.restaurant,
                                goalKey: 'nutrition',
                                selected: _selectedGoals.contains('nutrition'),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: 'Lose Weight',
                                subtitle: 'Achieve a healthy weight',
                                iconBackground: AfiaColors.orangeContainer,
                                icon: Icons.monitor_weight,
                                goalKey: 'lose_weight',
                                selected: _selectedGoals.contains('lose_weight'),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: 'Build Muscle',
                                subtitle: 'Gain strength and energy',
                                iconBackground: AfiaColors.blueContainer,
                                icon: Icons.fitness_center,
                                goalKey: 'build_muscle',
                                selected: _selectedGoals.contains('build_muscle'),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: 'Stay Healthy',
                                subtitle: 'Maintain wellness daily',
                                iconBackground: AfiaColors.redContainer,
                                icon: Icons.favorite,
                                goalKey: 'stay_healthy',
                                selected: _selectedGoals.contains('stay_healthy'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AfiaColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AfiaSpacing.sm),
                        Text(
                          'You can select multiple goals',
                          style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AfiaSpacing.pageMargin, 0, AfiaSpacing.pageMargin, AfiaSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteNames.main,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AfiaColors.primary,
                    foregroundColor: AfiaColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text('Continue', style: AfiaTypography.cardTitle.copyWith(color: AfiaColors.onPrimary)),
                ),
              ),
              const SizedBox(height: AfiaSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNames.main,
                    (route) => false,
                  ),
                  child: Text(
                    'Skip for now',
                    style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
