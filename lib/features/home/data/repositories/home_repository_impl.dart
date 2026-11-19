import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/error_mapper.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/home/data/datasources/home_remote_data_source.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    return _handleCall(() => _remoteDataSource.getBanners());
  }

  Future<Either<Failure, T>> _handleCall<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final result = await call();
      return Right(result);
    } on Exceptions catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      throw Left(UnknownFailure(e.toString()));
    }
  }
}
