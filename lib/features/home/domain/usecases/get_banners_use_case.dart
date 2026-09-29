import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';
import 'package:setra/features/home/domain/repositories/home_repository.dart';

class GetBannersUseCase {
  GetBannersUseCase(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, List<BannerEntity>>> call() =>
      _repository.getBanners();
}
