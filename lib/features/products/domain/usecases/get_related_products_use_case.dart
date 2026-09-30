import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/repositories/products_repository.dart';

class GetRelatedProductsUseCase {
  final ProductsRepository productsRepository;

  GetRelatedProductsUseCase(this.productsRepository);

  Future<Either<Failure, List<ProductEntity>>> call(
    String productId, {
    int limit = 10,
  }) {
    if (productId.trim().isEmpty) {
      return Future.value(
        Left(ValidationFailure('product_id_required', 'invalid_id')),
      );
    }
    if (limit <= 0) {
      return Future.value(
        Left(ValidationFailure('invalid_limit', 'invalid_limit')),
      );
    }
    return productsRepository.getRelatedProducts(productId, limit: limit);
  }
}
