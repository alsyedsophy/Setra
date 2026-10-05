import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    ProductFilter? filter,
    ProductSort? sort,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String id);

  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );

  Future<Either<Failure, List<ProductEntity>>> getRelatedProducts(
    String productId, {
    int limit = 10,
  });
}
