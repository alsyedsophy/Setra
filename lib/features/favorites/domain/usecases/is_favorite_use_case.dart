import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  final FavoritesRepository repository;

  IsFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String productId, {String? variantId}) {
    return repository.isFavorite(productId, variantId: variantId);
  }
}
