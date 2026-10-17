import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId, {String? variantId}) {
    return repository.removeFavorite(productId, variantId: variantId);
  }
}
