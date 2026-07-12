import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/more/presentation/cubit/profile_form_state.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/usecases/get_more_profile.dart';
import 'package:afia/features/more/domain/usecases/update_user_profile.dart';
import 'package:afia/features/more/domain/usecases/get_diet_preferences.dart';
import 'package:afia/features/more/domain/usecases/update_diet_preferences.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit({
    required this.getMoreProfile,
    required this.updateUserProfile,
    required this.getDietPreferences,
    required this.updateDietPreferences,
  }) : super(const ProfileFormState());

  final GetMoreProfile getMoreProfile;
  final UpdateUserProfile updateUserProfile;
  final GetDietPreferences getDietPreferences;
  final UpdateDietPreferences updateDietPreferences;

  UserProfile? _currentProfile;
  DietPreferences? _currentDietPrefs;

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

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    final profileRes = await getMoreProfile();
    final dietRes = await getDietPreferences();

    profileRes.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (profile) {
        _currentProfile = profile;
        dietRes.fold(
          (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
          (diet) {
            _currentDietPrefs = diet;
            emit(state.copyWith(
              isLoading: false,
              name: profile.name,
              age: profile.age?.toString() ?? '',
              gender: profile.gender ?? 'Female',
              heightCm: profile.heightCm?.toString() ?? '',
              weightKg: profile.weightKg?.toString() ?? '',
              activityLevel: profile.activityLevel ?? 'moderate',
              allergies: diet.allergies,
            ));
          },
        );
      },
    );
  }

  Future<void> save() async {
    emit(state.copyWith(isSaving: true, error: null));

    final profileToSave = _currentProfile ?? UserProfile(
      id: '',
      name: state.name,
    );

    final parsedAge = int.tryParse(state.age);
    final parsedHeight = double.tryParse(state.heightCm);
    final parsedWeight = double.tryParse(state.weightKg);

    final updatedProfile = profileToSave.copyWith(
      name: state.name,
      age: parsedAge,
      gender: state.gender,
      heightCm: parsedHeight,
      weightKg: parsedWeight,
      activityLevel: state.activityLevel,
    );

    final profileSaveRes = await updateUserProfile(updatedProfile);

    await profileSaveRes.fold(
      (failure) async {
        emit(state.copyWith(isSaving: false, error: failure.message));
      },
      (savedProfile) async {
        _currentProfile = savedProfile;
        
        final dietPrefs = _currentDietPrefs ?? const DietPreferences();
        final updatedDiet = dietPrefs.copyWith(
          allergies: state.allergies,
        );

        final dietSaveRes = await updateDietPreferences(updatedDiet);
        dietSaveRes.fold(
          (failure) => emit(state.copyWith(isSaving: false, error: failure.message)),
          (savedDiet) {
            _currentDietPrefs = savedDiet;
            emit(state.copyWith(isSaving: false, isSuccess: true));
          },
        );
      },
    );
  }

  void resetSuccess() => emit(state.copyWith(isSuccess: false));
}
