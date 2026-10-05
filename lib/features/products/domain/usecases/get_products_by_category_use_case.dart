import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/products_domain.dart';

class GetProductsByCategoryUseCase {
  final ProductsRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String categoryId) {
    if (categoryId.isEmpty) {
      throw ValidationFailure("category_id_required", "invalid_id");
    }
    return repository.getProductsByCategory(categoryId);
  }
}
