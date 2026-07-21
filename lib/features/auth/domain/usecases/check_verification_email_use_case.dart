import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

class CheckVerificationEmailUseCase {
  final AuthRepository authRepository;

  CheckVerificationEmailUseCase(this.authRepository);

  Future<Either<Failure, bool>> call() {
    return authRepository.checkEmailVerification();
  }
}
