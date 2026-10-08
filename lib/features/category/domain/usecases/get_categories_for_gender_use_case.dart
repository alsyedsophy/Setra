import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';
import 'package:setra/features/category/domain/repositories/category_repository.dart';

class GetCategoriesForGenderUseCase {
  final CategoryRepository categoryRepository;

  GetCategoriesForGenderUseCase(this.categoryRepository);

  Future<Either<Failure, List<CategoryEntity>>> call(String gender) {
    if (gender.trim().isEmpty) {
      return Future.value(
        Left(ValidationFailure('category_id_required', 'invalid_id')),
      );
    } else {
      return categoryRepository.getCategoriesForGender(gender);
    }
  }
}
