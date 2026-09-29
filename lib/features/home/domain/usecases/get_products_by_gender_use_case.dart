import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class GetProductsByGenderUseCase {
  final HomeRepository _homeRepository;

  GetProductsByGenderUseCase(this._homeRepository);

  Future<Either<Failure, List<ProductEntity>>> call(ProductGender gender) =>
      _homeRepository.getProductsByGender(gender);
}
