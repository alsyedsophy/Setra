import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository authRepository;

  GetCurrentUserUseCase({required this.authRepository});

  Future<Either<Failure, UserEntity?>> call() {
    return authRepository.getCurrentUser();
  }
}
