import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map((model) => model);

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    return _handleAuthCall(() async {
      return await _remoteDataSource.getCurrentUser();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _handleAuthCall(() async {
      return await _remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
    });
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    return _handleAuthCall(() async {
      return await _remoteDataSource.registerWithEmailAndPassword(
        name,
        email,
        password,
      );
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    return _handleAuthCall(() async {
      return await _remoteDataSource.signInWithGoogle();
    });
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerification() async {
    return _handleAuthCall(() async {
      return await _remoteDataSource.checkEmailVerified();
    });
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    return _handleAuthCall(() async {
      await _remoteDataSource.sendEmailVerification();
      return;
    });
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    return _handleAuthCall(() async {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return;
    });
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return _handleAuthCall(() async {
      await _remoteDataSource.signOut();
      return;
    });
  }

  Future<Either<Failure, T>> _handleAuthCall<T>(
    Future<T> Function() call,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final result = await call();
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
