import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository authRepository;

  SendEmailVerificationUseCase(this.authRepository);

  Future<Either<Failure, void>> call() {
    return authRepository.sendEmailVerification();
  }
}
