import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:setra/features/profile/data/models/profile_model.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() {
    return _handleProfileCall(() => _remoteDataSource.getProfile());
  }

  @override
  Future<Either<Failure, void>> createProfile(ProfileEntity profile) {
    return _handleProfileCall(() async {
      await _remoteDataSource.createProfile(ProfileModel.fromEntity(profile));
    });
  }

  @override
  Future<Either<Failure, ProfileEntity>> ensureProfile(ProfileEntity profile) {
    return _handleProfileCall(
      () => _remoteDataSource.ensureProfile(ProfileModel.fromEntity(profile)),
    );
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile) {
    return _handleProfileCall(
      () => _remoteDataSource.updateProfile(ProfileModel.fromEntity(profile)),
    );
  }

  Future<Either<Failure, T>> _handleProfileCall<T>(
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
