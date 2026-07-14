import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/more/presentation/cubit/more_state.dart';
import 'package:afia/features/more/domain/usecases/get_more_profile.dart';
import 'package:afia/features/more/domain/usecases/upload_profile_image.dart';
import 'package:image_picker/image_picker.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit({
    required this.getMoreProfile,
    required this.uploadProfileImageUsecase,
  }) : super(const MoreState());

  final GetMoreProfile getMoreProfile;
  final UploadProfileImage uploadProfileImageUsecase;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    final result = await getMoreProfile();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (profile) {
        final initials = profile.name
            .trim()
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join()
            .toUpperCase();
        emit(state.copyWith(
          isLoading: false,
          name: profile.name,
          initials: initials,
          profileImagePath: profile.photoUrl ?? '',
          weightKg: profile.weightKg ?? 0.0,
          heightCm: profile.heightCm ?? 0.0,
          currentGoal: profile.currentGoal ?? 'Balanced',
          streakDays: profile.streakDays,
        ));
      },
    );
  }

  void updateName(String name) {
    final initials = name
        .trim()
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    emit(state.copyWith(name: name, initials: initials));
  }

  Future<void> updateProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      emit(state.copyWith(isLoading: true));

      AppLogger.info('MoreCubit: Uploading profile image ${image.name}');
      final result = await uploadProfileImageUsecase(bytes, image.name);

      result.fold(
        (failure) {
          AppLogger.error('MoreCubit: Upload profile image failed: ${failure.message}');
          emit(state.copyWith(isLoading: false));
        },
        (publicUrl) {
          AppLogger.info('MoreCubit: Upload profile image succeeded. publicUrl = $publicUrl');
          emit(state.copyWith(
            isLoading: false,
            profileImagePath: publicUrl,
            profileImageBytes: bytes,
          ));
        },
      );
    }
  }
}
