import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

/// Authenticates a user with email and password.
class LoginUseCase {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) => _authRepository.signInWithEmailAndPassword(email, password);
}
