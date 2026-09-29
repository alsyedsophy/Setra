import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class GetProductsByTagsUseCase {
  final HomeRepository _homeRepository;

  GetProductsByTagsUseCase(this._homeRepository);

  Future<Either<Failure, List<ProductEntity>>> call(String tag) =>
      _homeRepository.getProductsByTag(tag);
}
