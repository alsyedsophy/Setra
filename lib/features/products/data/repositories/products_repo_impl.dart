import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/products/data/datasources/products_remote_data_source.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';
import 'package:setra/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ProductsRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    ProductFilter? filter,
    ProductSort? sort,
  }) async {
    return _handleCall(
      () => _remoteDataSource.getProducts(filter: filter, sort: sort),
    );
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    return _handleCall(() => _remoteDataSource.getProductById(id));
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
  Future<Either<Failure, List<ProductEntity>>> getRelatedProducts(
    String productId, {
    int limit = 10,
  }) async {
    return _handleCall(
      () => _remoteDataSource.getRelatedProducts(productId, limit: limit),
    );
  }

  // ============ Generic Handler ============

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
