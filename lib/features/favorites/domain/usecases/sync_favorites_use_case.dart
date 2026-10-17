import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';

class SyncFavoritesUseCase {
  final FavoritesRepository repository;

  SyncFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.syncFavorites();
  }
}
