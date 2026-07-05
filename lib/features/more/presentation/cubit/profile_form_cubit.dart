import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/more/presentation/cubit/profile_form_state.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit() : super(const ProfileFormState());

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateAge(String value) => emit(state.copyWith(age: value));
  void updateGender(String value) => emit(state.copyWith(gender: value));
  void updateHeight(String value) => emit(state.copyWith(heightCm: value));
  void updateWeight(String value) => emit(state.copyWith(weightKg: value));
  void updateActivityLevel(String value) =>
      emit(state.copyWith(activityLevel: value));
  void toggleAllergy(String allergy) {
    final allergies = List<String>.from(state.allergies);
    if (allergies.contains(allergy)) {
      allergies.remove(allergy);
    } else {
      allergies.add(allergy);
    }
    emit(state.copyWith(allergies: allergies));
  }

  Future<void> save() async {
    emit(state.copyWith(isSaving: true, error: null));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isSaving: false, isSuccess: true));
  }

  void resetSuccess() => emit(state.copyWith(isSuccess: false));
}
