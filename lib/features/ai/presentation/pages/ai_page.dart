import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/network/api_client.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/core/widgets/afia_error_state.dart';
import 'package:afia/features/ai/data/datasources/ai_remote_data_source.dart';
import 'package:afia/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/ai/domain/usecases/analyze_plate.dart';
import 'package:afia/features/ai/presentation/bloc/ai_bloc.dart';
import 'package:afia/features/ai/presentation/bloc/ai_event.dart';
import 'package:afia/features/ai/presentation/bloc/ai_state.dart';
import 'package:afia/features/ai/presentation/widgets/ai_confirmation_sheet.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiBloc(
        analyzePlate: AnalyzePlate(
          repository: AiRepositoryImpl(
            remoteDataSource: AiRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
          ),
        ),
      ),
      child: const _AiPageView(),
    );
  }
}

class _AiPageView extends StatefulWidget {
  const _AiPageView();

  @override
  State<_AiPageView> createState() => _AiPageViewState();
}

class _AiPageViewState extends State<_AiPageView> {
  bool _shouldShowConfirmationSheet = false;

  Future<void> _pickImage() async {
    final bloc = context.read<AiBloc>();
    final image = await bloc.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    _shouldShowConfirmationSheet = true;
    bloc.add(AnalyzePlateRequested(image));
  }

  void _showConfirmationSheet(PlateAnalysisResult result) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (sheetContext) {
        return AiConfirmationSheet(
          result: result,
          onConfirm: (updatedResult, slotType) {
            _shouldShowConfirmationSheet = false;

            // 1. Add immediately to the local MealsCubit for instant UI feedback
            final mealSummary = MealSummary(
              id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
              name: updatedResult.foodName,
              emoji: '🤖',
              servingLabel: '${updatedResult.estimatedQuantityG}g',
              calories: updatedResult.calories,
            );
            final mealsCubit = context.read<MealsCubit?>();
            mealsCubit?.addMealToSlot(slotType, mealSummary);

            // 2. Mark the confirmation complete in the AI flow.
            context.read<AiBloc>().add(
              ConfirmPlateAnalysis(updatedResult, slotType),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<AiBloc, AiState>(
      listener: (context, state) {
        // Analysis-level error — show snackbar
        if (state is AiError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          return;
        }

        // Analysis succeeded — open the confirmation sheet
        if (state is AiSuccess && _shouldShowConfirmationSheet) {
          _shouldShowConfirmationSheet = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showConfirmationSheet(state.result);
          });
          return;
        }

        // Save succeeded
        if (state is AiSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr
                    ? 'تم حفظ الوجبة في قائمة وجباتك.'
                    : 'Meal saved to your meals list.',
              ),
            ),
          );
          return;
        }

        // Save failed — meal was already added locally to MealsCubit,
        // so just notify the user; don't re-open the sheet.
        if (state is AiSaveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr
                    ? 'تمت الإضافة محلياً. خطأ في المزامنة: ${state.message}'
                    : 'Added locally. Sync error: ${state.message}',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AfiaColors.scaffoldBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'التقط صورة طبقك' : 'Snap Your Plate',
                  style: AfiaTypography.screenTitle,
                ),
                Text(
                  isAr
                      ? 'امسح وجبتك واحفظها في أفيا'
                      : 'Scan a meal and save it to Afia',
                  style: AfiaTypography.label.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AfiaSpacing.pageMargin,
                AfiaSpacing.md,
                AfiaSpacing.pageMargin,
                AfiaSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AfiaSpacing.lg),
                    decoration: BoxDecoration(
                      color: AfiaColors.surface,
                      borderRadius: BorderRadius.circular(AfiaRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: AfiaColors.primary.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AfiaColors.primaryContainer,
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: AfiaColors.primary,
                          ),
                        ),
                        const SizedBox(width: AfiaSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr
                                    ? 'مسح الوجبة بالذكاء الاصطناعي'
                                    : 'AI meal scanning',
                                style: AfiaTypography.cardTitle,
                              ),
                              const SizedBox(height: AfiaSpacing.xs),
                              Text(
                                isAr
                                    ? 'ارفع صورة طبقك لتقدير الوجبة وحفظها في قائمة وجباتك.'
                                    : 'Upload a photo of your plate to estimate the meal and save it to your meals list.',
                                style: AfiaTypography.body.copyWith(
                                  color: AfiaColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AfiaSpacing.lg),

                  // Content area
                  if (state is AiLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is AiSuccess)
                    Expanded(
                      child: _AnalysisCard(result: state.result, isAr: isAr),
                    )
                  else if (state is AiSaved)
                    Expanded(
                      child: _AnalysisCard(result: state.result, isAr: isAr),
                    )
                  else if (state is AiSaveError)
                    // Keep showing the result card — save error is shown in snackbar
                    Expanded(
                      child: _AnalysisCard(result: state.result, isAr: isAr),
                    )
                  else if (state is AiError)
                    Expanded(
                      child: SingleChildScrollView(
                        child: AfiaErrorState(
                          title: isAr
                              ? 'فشل تحليل الصورة'
                              : 'Image analysis failed',
                          message: state.message,
                          buttonText: isAr ? 'حاول مجدداً' : 'Try again',
                          onRetry: _pickImage,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: _EmptyState(
                        title: isAr
                            ? 'جاهز لفحص طبقك'
                            : 'Ready to inspect a plate',
                        subtitle: isAr
                            ? 'اضغط الزر أدناه لاختيار صورة وجبة ومراجعة تفاصيل القيم الغذائية.'
                            : 'Tap the button below to choose a meal photo and review the parsed nutrition details.',
                        actionLabel: isAr ? 'تحليل صورة' : 'Analyze a photo',
                        onAction: _pickImage,
                      ),
                    ),

                  const SizedBox(height: AfiaSpacing.md),

                  // Main action button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: (state is AiLoading) ? null : _pickImage,
                      icon: const Icon(Icons.photo_camera_rounded),
                      label: Text(isAr ? 'التقط صورة طبقك' : 'Snap your plate'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AfiaSpacing.lg,
                        ),
                        backgroundColor: AfiaColors.primary,
                        foregroundColor: AfiaColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AfiaRadius.lg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // NO bottomNavigationBar
        );
      },
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.result, required this.isAr});

  final PlateAnalysisResult result;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(AfiaRadius.lg),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'الوجبة المحللة' : 'Parsed meal',
              style: AfiaTypography.cardTitle,
            ),
            const SizedBox(height: AfiaSpacing.sm),
            Text(
              result.foodName,
              style: AfiaTypography.statValue.copyWith(fontSize: 24),
            ),
            const SizedBox(height: AfiaSpacing.lg),
            _MetricRow(
              label: isAr ? 'الكمية' : 'Quantity',
              value: '${result.estimatedQuantityG} g',
            ),
            _MetricRow(
              label: isAr ? 'السعرات' : 'Calories',
              value: '${result.calories} ${isAr ? 'سعرة' : 'kcal'}',
            ),
            _MetricRow(
              label: isAr ? 'البروتين' : 'Protein',
              value: '${result.proteinG.toStringAsFixed(1)} g',
            ),
            _MetricRow(
              label: isAr ? 'الكالسيوم' : 'Calcium',
              value: '${result.calciumMg} mg',
            ),
            const SizedBox(height: AfiaSpacing.lg),
            Text(
              isAr ? 'الفيتامينات' : 'Vitamins',
              style: AfiaTypography.cardTitle,
            ),
            const SizedBox(height: AfiaSpacing.sm),
            Wrap(
              spacing: AfiaSpacing.sm,
              runSpacing: AfiaSpacing.sm,
              children: result.vitamins
                  .map(
                    (vitamin) => Chip(
                      backgroundColor: AfiaColors.primaryContainer,
                      label: Text(
                        vitamin,
                        style: AfiaTypography.label.copyWith(
                          color: AfiaColors.onPrimaryContainer,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(AfiaRadius.lg),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 40,
            color: AfiaColors.primary,
          ),
          const SizedBox(height: AfiaSpacing.md),
          Text(title, style: AfiaTypography.cardTitle),
          const SizedBox(height: AfiaSpacing.sm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AfiaTypography.body.copyWith(
              color: AfiaColors.textSecondary,
            ),
          ),
          const SizedBox(height: AfiaSpacing.lg),
          FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.photo_camera_rounded),
            label: Text(actionLabel),
            style: FilledButton.styleFrom(
              backgroundColor: AfiaColors.primary,
              foregroundColor: AfiaColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.lg,
                vertical: AfiaSpacing.md,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AfiaSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AfiaTypography.body.copyWith(
                color: AfiaColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AfiaTypography.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
