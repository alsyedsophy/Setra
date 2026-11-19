import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/error_mapper.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/category/data/datasources/category_remote_data_source.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';
import 'package:setra/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return _handleCall(() => _remoteDataSource.getCategories());
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    return _handleCall(() => _remoteDataSource.getCategoryById(categoryId));
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getFeaturedCategories() async {
    return _handleCall(() => _remoteDataSource.getFeaturedCategories());
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesForGender(
    String gender,
  ) async {
    return _handleCall(() => _remoteDataSource.getCategoriesForGender(gender));
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
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
