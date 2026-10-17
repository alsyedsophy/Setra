import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';

class WatchFavouritesStream {
  final FavoritesRepository repository;

  WatchFavouritesStream(this.repository);

  Stream<List<FavoriteItem>> call() => repository.watchFavorites();
}
