import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/home/domain/entities/category_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, List<CategoryEntity>>> call() => _repository.getCategories();
}