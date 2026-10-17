import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(FavoriteItem item) {
    return repository.addFavorite(item);
  }
}
