import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, bool>> checkEmailVerification();
  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, void>> signOut();
}
