import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/repositories/products_repository.dart';

class GetProductByIdUseCase {
  final ProductsRepository productsRepository;

  GetProductByIdUseCase(this.productsRepository);

  Future<Either<Failure, ProductEntity>> call(String id) {
    if (id.trim().isEmpty) {
      return Future.value(
        Left(ValidationFailure('product_id_required', 'invalid_id')),
      );
    }
    return productsRepository.getProductById(id);
  }
}
