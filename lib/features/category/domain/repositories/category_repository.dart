import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  Future<Either<Failure, CategoryEntity>> getCategoryById(String categoryId);

  Future<Either<Failure, List<CategoryEntity>>> getFeaturedCategories();

  Future<Either<Failure, List<CategoryEntity>>> getCategoriesForGender(
    String gender,
  );
}
