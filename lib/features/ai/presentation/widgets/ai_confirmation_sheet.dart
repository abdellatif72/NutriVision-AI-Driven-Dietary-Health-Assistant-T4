import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:flutter/material.dart';

/// Called when the user confirms the meal and selects a slot.
/// [result] is the (possibly edited) plate analysis.
/// [slotType] is one of: 'breakfast', 'lunch', 'dinner', 'snack'.
typedef AiConfirmCallback = void Function(
  PlateAnalysisResult result,
  String slotType,
);

// ---------------------------------------------------------------------------
// Step 1 — Review & edit nutrition details
// ---------------------------------------------------------------------------

class AiConfirmationSheet extends StatefulWidget {
  const AiConfirmationSheet({
    super.key,
    required this.result,
    required this.onConfirm,
  });

  final PlateAnalysisResult result;
  final AiConfirmCallback onConfirm;

  @override
  State<AiConfirmationSheet> createState() => _AiConfirmationSheetState();
}

class _AiConfirmationSheetState extends State<AiConfirmationSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _calciumController;
  late PlateAnalysisResult _result;

  @override
  void initState() {
    super.initState();
    _result = widget.result;
    _nameController = TextEditingController(text: _result.foodName);
    _quantityController = TextEditingController(
      text: _result.estimatedQuantityG.toString(),
    );
    _caloriesController = TextEditingController(
      text: _result.calories.toString(),
    );
    _proteinController = TextEditingController(
      text: _result.proteinG.toString(),
    );
    _carbsController = TextEditingController(
      text: _result.carbsG.toString(),
    );
    _fatController = TextEditingController(
      text: _result.fatG.toString(),
    );
    _calciumController = TextEditingController(
      text: _result.calciumMg.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _calciumController.dispose();
    super.dispose();
  }

  void _updateResult([String? _]) {
    setState(() {
      _result = _result.copyWith(
        foodName: _nameController.text.trim().isEmpty
            ? _result.foodName
            : _nameController.text.trim(),
        estimatedQuantityG:
            int.tryParse(_quantityController.text) ??
            _result.estimatedQuantityG,
        calories: int.tryParse(_caloriesController.text) ?? _result.calories,
        proteinG: double.tryParse(_proteinController.text) ?? _result.proteinG,
        carbsG: double.tryParse(_carbsController.text) ?? _result.carbsG,
        fatG: double.tryParse(_fatController.text) ?? _result.fatG,
        calciumMg: int.tryParse(_calciumController.text) ?? _result.calciumMg,
      );
    });
  }

  void _openSlotPicker(BuildContext ctx, bool isAr) {
    Navigator.pop(ctx);
    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (_) => AiSlotPickerSheet(
        result: _result,
        isAr: isAr,
        onSlotSelected: (slotType) => widget.onConfirm(_result, slotType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AfiaSpacing.pageMargin,
          right: AfiaSpacing.pageMargin,
          top: AfiaSpacing.lg,
          bottom: AfiaSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AfiaColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AfiaSpacing.lg),
            Text(
              isAr ? 'تأكيد الذكاء الاصطناعي' : 'AI Confirmation',
              style: AfiaTypography.cardTitle,
            ),
            const SizedBox(height: AfiaSpacing.sm),
            Text(
              isAr
                  ? 'راجع تفاصيل الوجبة المستخرجة وعدّلها قبل حفظها.'
                  : 'Review the parsed meal details and adjust anything before saving it.',
              style: AfiaTypography.body.copyWith(
                color: AfiaColors.textSecondary,
              ),
            ),
            const SizedBox(height: AfiaSpacing.lg),
            _buildTextField(
              isAr ? 'اسم الوجبة' : 'Meal name',
              _nameController,
              onChanged: _updateResult,
            ),
            const SizedBox(height: AfiaSpacing.md),
            _buildTextField(
              isAr ? 'الكمية (جرام)' : 'Quantity (g)',
              _quantityController,
              keyboardType: TextInputType.number,
              onChanged: _updateResult,
            ),
            const SizedBox(height: AfiaSpacing.md),
            _buildTextField(
              isAr ? 'السعرات الحرارية' : 'Calories',
              _caloriesController,
              keyboardType: TextInputType.number,
              onChanged: _updateResult,
            ),
            const SizedBox(height: AfiaSpacing.md),
            _buildTextField(
              isAr ? 'البروتين (جرام)' : 'Protein (g)',
              _proteinController,
              keyboardType: TextInputType.number,
              onChanged: _updateResult,
            ),
            const SizedBox(height: AfiaSpacing.md),
            _buildTextField(
              isAr ? 'الكربوهيدرات (جرام)' : 'Carbs (g)',
              _carbsController,
              keyboardType: TextInputType.number,
              onChanged: _updateResult,
            ),
            const SizedBox(height: AfiaSpacing.md),
            _buildTextField(
              isAr ? 'الدهون (جرام)' : 'Fat (g)',
              _fatController,
              keyboardType: TextInputType.number,
              onChanged: _updateResult,
            ),
            const SizedBox(height: AfiaSpacing.lg),
            Wrap(
              spacing: AfiaSpacing.sm,
              runSpacing: AfiaSpacing.sm,
              children: _result.vitamins
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
            const SizedBox(height: AfiaSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openSlotPicker(context, isAr),
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: Text(isAr ? 'أضف إلى الوجبات' : 'Add to meals'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AfiaSpacing.lg),
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AfiaTypography.label),
        const SizedBox(height: AfiaSpacing.sm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AfiaColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AfiaRadius.md),
              borderSide: const BorderSide(color: AfiaColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AfiaRadius.md),
              borderSide: const BorderSide(color: AfiaColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AfiaRadius.md),
              borderSide: const BorderSide(color: AfiaColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 — Choose meal slot
// ---------------------------------------------------------------------------

class AiSlotPickerSheet extends StatelessWidget {
  const AiSlotPickerSheet({
    super.key,
    required this.result,
    required this.isAr,
    required this.onSlotSelected,
  });

  final PlateAnalysisResult result;
  final bool isAr;
  final ValueChanged<String> onSlotSelected;

  static const _slots = [
    _SlotOption(type: 'breakfast', emoji: '🥣', nameEn: 'Breakfast', nameAr: 'الإفطار'),
    _SlotOption(type: 'lunch',     emoji: '🥗', nameEn: 'Lunch',     nameAr: 'الغداء'),
    _SlotOption(type: 'dinner',    emoji: '🍛', nameEn: 'Dinner',    nameAr: 'العشاء'),
    _SlotOption(type: 'snack',     emoji: '🍎', nameEn: 'Snack',     nameAr: 'وجبة خفيفة'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.lg,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AfiaColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AfiaSpacing.lg),
            Text(
              isAr ? 'أضف إلى وجبة' : 'Add to meal slot',
              style: AfiaTypography.cardTitle,
            ),
            const SizedBox(height: AfiaSpacing.md),
            // Mini meal summary chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AfiaSpacing.lg,
                vertical: AfiaSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AfiaColors.primaryContainer,
                borderRadius: BorderRadius.circular(AfiaRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AfiaColors.primary, size: 18),
                  const SizedBox(width: AfiaSpacing.sm),
                  Expanded(
                    child: Text(
                      result.foodName,
                      style: AfiaTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AfiaColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  Text(
                    '${result.calories} kcal',
                    style: AfiaTypography.label
                        .copyWith(color: AfiaColors.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AfiaSpacing.lg),
            Text(
              isAr
                  ? 'اختر الوجبة التي تريد الإضافة إليها:'
                  : 'Which slot would you like to add it to?',
              style: AfiaTypography.body
                  .copyWith(color: AfiaColors.textSecondary),
            ),
            const SizedBox(height: AfiaSpacing.md),
            ..._slots.map(
              (slot) => _SlotTile(
                slot: slot,
                isAr: isAr,
                onTap: () {
                  Navigator.pop(context);
                  onSlotSelected(slot.type);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotOption {
  const _SlotOption({
    required this.type,
    required this.emoji,
    required this.nameEn,
    required this.nameAr,
  });

  final String type;
  final String emoji;
  final String nameEn;
  final String nameAr;

  String name(bool isAr) => isAr ? nameAr : nameEn;
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.slot,
    required this.isAr,
    required this.onTap,
  });

  final _SlotOption slot;
  final bool isAr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AfiaSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AfiaRadius.md),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AfiaSpacing.lg,
              vertical: AfiaSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(AfiaRadius.md),
              border: Border.all(color: AfiaColors.divider),
            ),
            child: Row(
              children: [
                Text(slot.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: AfiaSpacing.md),
                Expanded(
                  child: Text(
                    slot.name(isAr),
                    style: AfiaTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AfiaColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AfiaColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
