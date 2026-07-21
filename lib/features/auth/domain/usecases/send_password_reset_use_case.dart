import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

/// Sends a password-reset email to the given address.
class SendPasswordResetUseCase {
  SendPasswordResetUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<Failure, void>> call({required String email}) =>
      _authRepository.sendPasswordResetEmail(email);
}
