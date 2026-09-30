import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';
import 'package:setra/features/home/domain/entities/category_entity.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();

  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ProductEntity>>> newArrivalProducts();
  Future<Either<Failure, List<ProductEntity>>> featuredProducts();

  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );

  Future<Either<Failure, List<ProductEntity>>> getProductsByTag(String tag);

  Future<Either<Failure, List<ProductEntity>>> getProductsByGender(
    ProductGender gender,
  );
}
