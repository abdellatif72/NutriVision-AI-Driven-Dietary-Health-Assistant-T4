import 'package:afia/features/ai/domain/usecases/analyze_plate.dart';
import 'package:afia/features/ai/presentation/bloc/ai_event.dart';
import 'package:afia/features/ai/presentation/bloc/ai_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc({required this.analyzePlate, ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker(),
      super(AiInitial()) {
    on<AnalyzePlateRequested>(_onAnalyzePlateRequested);
    on<ConfirmPlateAnalysis>(_onConfirmPlateAnalysis);
    on<PickImageEvent>(_onPickImageEvent);
  }

  final AnalyzePlate analyzePlate;
  final ImagePicker _imagePicker;

  Future<void> _onAnalyzePlateRequested(
    AnalyzePlateRequested event,
    Emitter<AiState> emit,
  ) async {
    emit(AiLoading());

    final failureOrResult = await analyzePlate(event.image);
    failureOrResult.fold(
      (failure) => emit(AiError(failure.message)),
      (result) => emit(AiSuccess(result)),
    );
  }

  Future<void> _onPickImageEvent(
    PickImageEvent event,
    Emitter<AiState> emit,
  ) async {
    final image = await pickImage(source: event.source);
    if (image == null) return;

    emit(AiLoading());

    final failureOrResult = await analyzePlate(image);
    failureOrResult.fold(
      (failure) => emit(AiError(failure.message)),
      (result) => emit(AiSuccess(result)),
    );
  }

  Future<void> _onConfirmPlateAnalysis(
    ConfirmPlateAnalysis event,
    Emitter<AiState> emit,
  ) async {
    // The Meals screen currently logs meals locally through MealsCubit.
    // Snap Your Plate follows that same path; persistence can be added once
    // the meals feature has an authenticated Supabase write flow.
    emit(AiSaved(event.result));
  }

  Future<XFile?> pickImage({required ImageSource source}) async {
    return _imagePicker.pickImage(source: source);
  }
}
