import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/is_favorite_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/sync_favorites_use_case.dart';
import 'package:setra/features/favorites/domain/usecases/watch_favourites_stream.dart';
import 'package:setra/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;
  final IsFavoriteUseCase _isFavorite;
  final SyncFavoritesUseCase _syncFavorites;
  final WatchFavouritesStream _watchFavourites;

  FavoritesCubit(
    this._addFavorite,
    this._removeFavorite,
    this._isFavorite,
    this._syncFavorites,
    this._watchFavourites,
  ) : super(const FavoritesState()) {
    _init();
    log(state.toString());
  }

  StreamSubscription? _sub;

  void _init() {
    emit(state.copyWith(status: FavoritesStatus.loading, clearError: true));

    _sub = _watchFavourites().listen(
      (items) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FavoritesStatus.success,
              items: items,
              clearError: true,
            ),
          );
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FavoritesStatus.failure,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );

    // Kick off an initial sync with the remote.
    _sync();
  }

  /// Toggle a favorite on/off.
  /// Hive writes trigger the watch stream, so the UI updates automatically.
  Future<void> toggleFavorite(FavoriteItem item) async {
    final result = state.isFavorite(item.productId, variantId: item.variantId)
        ? await _removeFavorite(item.productId, variantId: item.variantId)
        : await _addFavorite(item);

    result.fold((failure) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: failure.message));
      }
    }, (_) {});
  }

  /// Convenience check used by screens that don't read the cubit state directly.
  Future<bool> isFavorited(String productId, {String? variantId}) async {
    final result = await _isFavorite(productId, variantId: variantId);
    return result.fold((_) => false, (value) => value);
  }

  /// Force a refresh / merge with the remote data source.
  Future<void> refresh() => _sync();

  Future<void> _sync() async {
    final result = await _syncFavorites();
    result.fold((failure) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: failure.message));
      }
    }, (_) {});
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
