import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:setra/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:setra/features/profile/presentation/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileState());

  Future<void> getProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearMessage: true));

    final result = await getProfileUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) {
        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            profile: profile,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    if (state.status == ProfileStatus.updating) return;

    emit(state.copyWith(status: ProfileStatus.updating, clearMessage: true));

    final result = await updateProfileUseCase(profile);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedProfile) {
        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            profile: updatedProfile,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
