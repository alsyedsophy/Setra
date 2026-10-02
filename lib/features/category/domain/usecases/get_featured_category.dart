import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';
import 'package:setra/features/category/domain/repositories/category_repository.dart';

class GetFeaturedCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetFeaturedCategoriesUseCase(this.categoryRepository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return categoryRepository.getFeaturedCategories();
  }
}
