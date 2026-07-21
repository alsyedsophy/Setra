import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

/// Signs the user in with a Google account.
class GoogleSignInUseCase {
  GoogleSignInUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<Failure, UserEntity>> call() =>
      _authRepository.signInWithGoogle();
}
