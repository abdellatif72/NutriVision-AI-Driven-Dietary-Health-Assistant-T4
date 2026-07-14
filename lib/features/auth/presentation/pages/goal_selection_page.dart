import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/features/auth/domain/usecases/calculate_daily_calories.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({super.key});

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  final List<String> _selectedGoals = [];
  bool _isLoading = false;

  Future<void> _saveOnboardingData(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectGoal)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final gender = args?['gender'] as String? ?? 'male';
      final weightKg = args?['weightKg'] as double? ?? 70.0;
      final heightCm = args?['heightCm'] as double? ?? 170.0;

      // Map goal
      String goalType = 'maintain';
      String currentGoal = 'stay_healthy';
      if (_selectedGoals.contains('lose_weight')) {
        goalType = 'lose';
        currentGoal = 'lose_weight';
      } else if (_selectedGoals.contains('build_muscle')) {
        goalType = 'gain';
        currentGoal = 'build_muscle';
      } else if (_selectedGoals.contains('nutrition')) {
        currentGoal = 'nutrition';
      }

      // Calculate BMR and daily calorie target
      final calculator = CalculateDailyCalories();
      final calcResult = calculator.call(CalculateDailyCaloriesParams(
        weightKg: weightKg,
        heightCm: heightCm,
        age: 25, // Default age since not collected on page
        gender: gender,
        activityLevel: 'moderately_active', // Default activity level
        goal: goalType,
      ));

      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      final userId = currentUser?.uid ?? '';
      final name = currentUser?.displayName ?? 'Afia User';

      // 1. Save User Profile
      final profile = UserProfile(
        id: userId,
        name: name,
        age: 25,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        activityLevel: 'moderately_active',
        currentGoal: currentGoal,
        streakDays: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 2. Save Diet Preferences
      final dietPrefs = DietPreferences(
        dietStyle: 'balanced',
        goalType: goalType,
        calorieTarget: calcResult.calorieTarget,
        carbsPct: 50,
        proteinPct: 20,
        fatPct: 30,
        waterGoalMl: 2500,
      );

      // Save using repository
      final moreRepo = sl<MoreRepository>();
      await moreRepo.updateProfile(profile);
      await moreRepo.updateDietPreferences(dietPrefs);

      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.main,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorSavingProfile(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
              padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
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
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AfiaSpacing.md,
                    vertical: AfiaSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AfiaColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.popular,
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
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: AfiaSpacing.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AfiaSpacing.xl),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.maybePop(context),
                        icon: Container(
                          padding: const EdgeInsetsDirectional.all(10),
                          decoration: BoxDecoration(
                            color: AfiaColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.lg),
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
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: AfiaSpacing.lg, vertical: AfiaSpacing.sm),
                        decoration: BoxDecoration(
                          color: AfiaColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.stepTwoOfTwo,
                          style: AfiaTypography.body.copyWith(
                            color: AfiaColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xl),
                    Text(
                      l10n.whatsYourGoal,
                      style: AfiaTypography.statValue.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: AfiaSpacing.sm),
                    Text(
                      l10n.tailorPlan,
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                    LayoutBuilder(
                      builder: (context, constraints) {
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
                                title: l10n.improveNutrition,
                                subtitle: l10n.eatHealthier,
                                iconBackground: AfiaColors.primary.withOpacity(0.16),
                                icon: Icons.restaurant,
                                goalKey: 'nutrition',
                                selected: _selectedGoals.contains('nutrition'),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: l10n.loseWeight,
                                subtitle: l10n.achieveHealthyWeight,
                                iconBackground: AfiaColors.orangeContainer,
                                icon: Icons.monitor_weight,
                                goalKey: 'lose_weight',
                                selected: _selectedGoals.contains('lose_weight'),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: l10n.buildMuscle,
                                subtitle: l10n.gainStrength,
                                iconBackground: AfiaColors.blueContainer,
                                icon: Icons.fitness_center,
                                goalKey: 'build_muscle',
                                selected: _selectedGoals.contains('build_muscle'),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _buildGoalCard(
                                title: l10n.stayHealthy,
                                subtitle: l10n.maintainWellness,
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
                          l10n.selectMultipleGoals,
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
          padding: const EdgeInsetsDirectional.fromSTEB(AfiaSpacing.pageMargin, 0, AfiaSpacing.pageMargin, AfiaSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _saveOnboardingData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AfiaColors.primary,
                    foregroundColor: AfiaColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AfiaColors.onPrimary,
                          ),
                        )
                      : Text(l10n.continueButton, style: AfiaTypography.cardTitle.copyWith(color: AfiaColors.onPrimary)),
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
                    l10n.skipForNow,
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
