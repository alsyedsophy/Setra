import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, void>> createProfile(ProfileEntity profile);

  // التأكد من وجود ملف شخصي، وإنشاؤه إذا لم يكن موجودًا
  Future<Either<Failure, ProfileEntity>> ensureProfile(ProfileEntity profile);

  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
}
