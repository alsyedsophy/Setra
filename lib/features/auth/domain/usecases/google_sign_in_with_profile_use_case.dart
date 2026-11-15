import 'package:dartz/dartz.dart';

import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/domain/use_cases/ensure_profile_use_case.dart';

class GoogleSignInWithProfileUseCase {
  final GoogleSignInUseCase _googleSignInUseCase;
  final EnsureProfileUseCase _ensureProfileUseCase;

  GoogleSignInWithProfileUseCase({
    required this._googleSignInUseCase,
    required this._ensureProfileUseCase,
  });

  Future<Either<Failure, UserEntity>> call() async {
    final authResult = await _googleSignInUseCase();

    UserEntity? user;
    Failure? authFailure;

    authResult.fold(
      (failure) => authFailure = failure,
      (result) => user = result,
    );

    if (authFailure != null) {
      return Left(authFailure!);
    }

    // إنشاء Profile فقط إذا لم يكن موجودًا
    final profile = ProfileEntity(
      id: user!.id,
      name: user!.name,
      email: user!.email,
      createdAt: DateTime.now(),
    );

    final profileResult = await _ensureProfileUseCase(profile);

    return profileResult.fold((failure) => Left(failure), (_) => Right(user!));
  }
}
