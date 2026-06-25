import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:afia/features/water/presentation/widgets/custom_water_amount_sheet.dart';
import 'package:afia/features/water/presentation/widgets/water_log_tile.dart';
import 'package:afia/features/water/presentation/widgets/water_preset_button.dart';
import 'package:afia/features/water/presentation/widgets/water_progress_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterRecordingPage extends StatelessWidget {
  const WaterRecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WaterRecordingCubit(),
      child: const _WaterRecordingView(),
    );
  }
}

class _WaterRecordingView extends StatelessWidget {
  const _WaterRecordingView();

  Future<void> _onPresetTap(BuildContext context, WaterPreset preset) async {
    final cubit = context.read<WaterRecordingCubit>();
    if (preset == WaterPreset.custom) {
      cubit.selectPreset(preset);
      final amount = await showCustomWaterAmountSheet(context);
      if (amount != null) cubit.addCustomAmount(amount);
      return;
    }
    cubit.addPreset(preset);
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
          icon: const Icon(Icons.arrow_back, color: AfiaColors.textPrimary),
        ),
        title: const Text(
          'Water logging',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AfiaColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<WaterRecordingCubit, WaterRecordingState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 8),
              Center(
                child: WaterProgressRing(
                  consumedMl: state.consumedMl,
                  goalMl: state.goalMl,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Your goal: ${(state.goalMl / 1000).toStringAsFixed(1)}L',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AfiaColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    WaterPresetButton(
                      preset: WaterPreset.cup,
                      selected: state.selectedPreset == WaterPreset.cup,
                      onTap: () => _onPresetTap(context, WaterPreset.cup),
                    ),
                    const SizedBox(width: 8),
                    WaterPresetButton(
                      preset: WaterPreset.pint,
                      selected: state.selectedPreset == WaterPreset.pint,
                      onTap: () => _onPresetTap(context, WaterPreset.pint),
                    ),
                    const SizedBox(width: 8),
                    WaterPresetButton(
                      preset: WaterPreset.custom,
                      selected: state.selectedPreset == WaterPreset.custom,
                      onTap: () => _onPresetTap(context, WaterPreset.custom),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Register today',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AfiaColors.textPrimary,
                  ),
                ),
              ),
              if (state.entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'No entries yet — tap a preset above to log water.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AfiaColors.textSecondary,
                    ),
                  ),
                )
              else
                ...state.entries.map(
                  (e) => WaterLogTile(
                    entry: e,
                    onDelete: () => context
                        .read<WaterRecordingCubit>()
                        .deleteEntry(e.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
