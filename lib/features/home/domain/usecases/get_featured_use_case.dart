import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class GetFeaturedUseCase {
  final HomeRepository _homeRepository;

  GetFeaturedUseCase(this._homeRepository);

  Future<Either<Failure, List<ProductEntity>>> call() =>
      _homeRepository.featuredProducts();
}
