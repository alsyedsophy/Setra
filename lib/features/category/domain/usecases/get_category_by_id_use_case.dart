import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';
import 'package:setra/features/category/domain/repositories/category_repository.dart';

class GetCategoryByIdUseCase {
  GetCategoryByIdUseCase(this._repository);

  final CategoryRepository _repository;

  Future<Either<Failure, CategoryEntity>> call(String categoryId) {
    if (categoryId.trim().isEmpty) {
      return Future.value(
        Left(ValidationFailure('category_id_required', 'invalid_id')),
      );
    } else {
      return _repository.getCategoryById(categoryId);
    }
  }
}
