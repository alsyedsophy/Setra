import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, List<ProductEntity>>> call(String categoryId) =>
      _repository.getProductsByCategory(categoryId);
}
