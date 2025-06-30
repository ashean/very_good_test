import 'package:bloc/bloc.dart';

import 'package:my_app/core/logging/app_logger.dart';
import 'package:my_app/user_profile/cubit/user_profile_state.dart';
import 'package:my_app/user_profile/repository/user_profile_repository.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._repository) : super(const UserProfileInitial());

  final UserProfileRepository _repository;

  Future<void> submitUserProfile({
    required String name,
    required int age,
    required double heightCm,
    required double weightKg,
  }) async {
    emit(const UserProfileLoading());
    try {
      await _repository.addUserProfile(
        name: name,
        age: age,
        heightCm: heightCm,
        weightKg: weightKg,
      );
      emit(const UserProfileFormSuccess());
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to save user profile',
        e,
        stackTrace,
        'UserProfileCubit',
      );
      emit(UserProfileFormError('Failed to save profile: $e'));
    }
  }

  Future<void> loadUserProfiles() async {
    emit(const UserProfileLoading());
    try {
      final profiles = await _repository.getAllUserProfiles();
      emit(UserProfileListLoaded(profiles));
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to load user profiles',
        e,
        stackTrace,
        'UserProfileCubit',
      );
      emit(UserProfileListError('Failed to load profiles: $e'));
    }
  }

  void resetToInitial() {
    emit(const UserProfileInitial());
  }
}
