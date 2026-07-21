import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

/// Signs the current user out.
class LogoutUseCase {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<Failure, void>> call() => _authRepository.signOut();
}
