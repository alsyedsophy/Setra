import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/home/data/datasources/home_remote_data_source.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';
import 'package:setra/features/home/domain/entities/category_entity.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    return _handleCall(() => _remoteDataSource.getBanners());
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return _handleCall(() => _remoteDataSource.getCategories());
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    return _handleCall(
      () => _remoteDataSource.getProductsByCategory(categoryId),
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    return _handleCall(() => _remoteDataSource.getProducts());
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> newArrivalProducts() async {
    return _handleCall(() => _remoteDataSource.newArrivalProducts());
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> featuredProducts() async {
    return _handleCall(() => _remoteDataSource.featuredProducts());
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByGender(
    ProductGender gender,
  ) async {
    return _handleCall(() => _remoteDataSource.getProductsByGender(gender));
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByTag(String tag) {
    return _handleCall(() => _remoteDataSource.getProductsByTag(tag));
  }

  Future<Either<Failure, T>> _handleCall<T>(Future<T> Function() call) async {
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
