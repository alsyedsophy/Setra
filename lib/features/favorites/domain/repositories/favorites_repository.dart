import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteItem>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(FavoriteItem item);
  Future<Either<Failure, void>> removeFavorite(
    String productId, {
    String? variantId,
  });
  Future<Either<Failure, bool>> isFavorite(
    String productId, {
    String? variantId,
  });
  Future<Either<Failure, void>> syncFavorites();
  Stream<List<FavoriteItem>> watchFavorites();
}
