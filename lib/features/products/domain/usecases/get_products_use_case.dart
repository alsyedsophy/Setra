import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';
import 'package:setra/features/products/domain/repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository productsRepository;

  GetProductsUseCase(this.productsRepository);

  Future<Either<Failure, List<ProductEntity>>> call({
    ProductFilter? filter,
    ProductSort? sort,
  }) {
    return productsRepository.getProducts(filter: filter, sort: sort);
  }
}
