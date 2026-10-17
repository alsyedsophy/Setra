import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:setra/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:setra/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:setra/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:setra/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/is_favorite_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/sync_favorites_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/watch_favourites_stream.dart';
import 'package:setra/features/favorites/presentation/cubit/favorites_cubit.dart';

Future<void> registerFavorites() async {
  final GetIt getIt = GetIt.instance;

  // ================= Hive Boxes =================
  // Hive stores map structures (serialized from FavoriteItemModel.toMap())
  final Box favBox = await Hive.openBox('favorites_box');
  final Box outBox = await Hive.openBox('favorites_outbox_box');

  // ============== Data sources =============
  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(favBox: favBox, outBox: outBox),
  );
  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  );

  // ================= Repository =============
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoriteRepositoryImpl(
      localDataSource: getIt<FavoritesLocalDataSource>(),
      remoteDataSource: getIt<FavoritesRemoteDataSource>(),
    ),
  );

  // ============== Use cases =================
  getIt.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<IsFavoriteUseCase>(
    () => IsFavoriteUseCase(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<SyncFavoritesUseCase>(
    () => SyncFavoritesUseCase(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<WatchFavouritesStream>(
    () => WatchFavouritesStream(getIt<FavoritesRepository>()),
  );

  // ==================== Cubit ===============
  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(
      getIt<AddFavoriteUseCase>(),
      getIt<RemoveFavoriteUseCase>(),
      getIt<IsFavoriteUseCase>(),
      getIt<SyncFavoritesUseCase>(),
      getIt<WatchFavouritesStream>(),
    ),
  );
}
