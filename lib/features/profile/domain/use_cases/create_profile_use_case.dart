import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/domain/repositories/profile_repository.dart';

class CreateProfileUseCase {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(ProfileEntity profile) {
    if (profile.id.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('User ID cannot be empty')));
    }

    if (profile.name.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('Name cannot be empty')));
    }

    return repository.createProfile(profile);
  }
}
