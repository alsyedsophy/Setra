import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(ProfileEntity profile) {
    if (profile.id.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('User ID cannot be empty')));
    }

    if (profile.name.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('Name cannot be empty')));
    }

    return repository.updateProfile(profile);
  }
}
