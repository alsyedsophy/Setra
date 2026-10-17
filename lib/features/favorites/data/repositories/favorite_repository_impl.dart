import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:setra/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:setra/features/favorites/data/models/favorite_model.dart';
import 'package:setra/features/favorites/data/models/pending_operation.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/domain/repositories/favorites_repository.dart';

class FavoriteRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  final FavoritesRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<FavoriteItem>>> getFavorites() async {
    try {
      final cached = await localDataSource.getCached();
      unawaited(syncFavorites());
      return Right(cached);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(FavoriteItem item) async {
    try {
      final model = FavoriteItemModel.fromEntity(item);
      final pending = PendingOperation(
        productId: item.productId,
        variantId: item.variantId,
        type: PendingOpType.add,
        item: model,
        createdAt: DateTime.now(),
      );

      await localDataSource.cache(model);
      await localDataSource.addToOutBox(pending);
      unawaited(syncFavorites());
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(
    String productId, {
    String? variantId,
  }) async {
    try {
      final pending = PendingOperation(
        productId: productId,
        variantId: variantId,
        type: PendingOpType.remove,
        createdAt: DateTime.now(),
      );

      await localDataSource.remove(productId, variantId: variantId);
      await localDataSource.addToOutBox(pending);
      unawaited(syncFavorites());
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(
    String productId, {
    String? variantId,
  }) async {
    try {
      final isFav = await localDataSource.isCached(
        productId,
        variantId: variantId,
      );
      unawaited(syncFavorites());
      return Right(isFav);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> syncFavorites() async {
    try {
      final pending = await localDataSource.getOutBox();
      if (pending.isEmpty) {
        return const Right(null);
      }

      final done = <PendingOperation>[];
      for (final op in pending) {
        try {
          switch (op.type) {
            case PendingOpType.add:
              await remoteDataSource.addFavourite(op.item!);
              break;
            case PendingOpType.remove:
              await remoteDataSource.removeFavorite(
                op.productId,
                variantId: op.variantId,
              );
              break;
          }
          done.add(op);
        } on AuthException {
          // Stop syncing - will retry later
          break;
        } on ServerException {
          // Stop syncing - will retry later
          break;
        }
      }

      if (done.isNotEmpty) {
        await localDataSource.clearOutBox(done);
      }

      // Merge local + remote to resolve conflicts (last-write-wins by addedAt)
      try {
        final local = await localDataSource.getCached();
        final remote = await remoteDataSource.getFavorites();
        final merged = _merge(local, remote);

        for (final item in merged) {
          await localDataSource.cache(item);
        }

        // Remove any local items not in merged set
        final remoteKeys = merged.map((e) => e.key).toSet();
        for (final l in local) {
          if (!remoteKeys.contains(l.key)) {
            await localDataSource.remove(l.productId, variantId: l.variantId);
          }
        }
      } on AuthException {}

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  List<FavoriteItemModel> _merge(
    List<FavoriteItemModel> local,
    List<FavoriteItemModel> remote,
  ) {
    final map = <String, FavoriteItemModel>{};
    for (final r in remote) {
      map[r.key] = r;
    }
    for (final l in local) {
      final existing = map[l.key];
      if (existing == null || l.addedAt.isAfter(existing.addedAt)) {
        map[l.key] = l;
      }
    }
    return map.values.toList();
  }

  @override
  Stream<List<FavoriteItem>> watchFavorites() =>
      localDataSource.watch().map((list) => list.cast<FavoriteItem>());
}
