import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/favorites/data/models/favorite_model.dart';
import 'package:setra/features/favorites/data/models/pending_operation.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteItemModel>> getCached();
  Future<void> cache(FavoriteItemModel item);
  Future<void> remove(String productId, {String? variantId});
  Future<bool> isCached(String productId, {String? variantId});
  Stream<List<FavoriteItemModel>> watch();

  // Pending operations (outbox)
  Future<void> addToOutBox(PendingOperation op);
  Future<List<PendingOperation>> getOutBox();
  Future<void> clearOutBox(List<PendingOperation> ops);
  Future<void> clearAll();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box _favBox;
  final Box _outBox;

  FavoritesLocalDataSourceImpl({required Box favBox, required Box outBox})
    : _favBox = favBox,
      _outBox = outBox;
  String _favKey(String pid, String? vid) => vid == null ? pid : '${pid}_$vid';

  @override
  Future<List<FavoriteItemModel>> getCached() async {
    try {
      log('Favorites count: ${_favBox.length}');
      log('Favorites values: ${_favBox.values}');
      return _favBox.values
          .map(
            (e) =>
                FavoriteItemModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to read Favourites');
    }
  }

  @override
  Future<void> cache(FavoriteItemModel item) async {
    try {
      log('====== Before Put ======');
      log('Box length before: ${_favBox.length}');
      await _favBox.put(_favKey(item.productId, item.variantId), item.toMap());
      log('=== AFTER PUT ===');
      log('Box length after: ${_favBox.length}');
      log('Box values after: ${_favBox.values}');
    } catch (e) {
      log('Cache exceprion : $e');
      throw CacheException(message: 'Failed to write Item');
    }
  }

  @override
  Future<void> remove(String productId, {String? variantId}) async {
    try {
      await _favBox.delete(_favKey(productId, variantId));
    } catch (e) {
      throw CacheException(message: 'Failed to Delete Item');
    }
  }

  @override
  Future<bool> isCached(String productId, {String? variantId}) async {
    try {
      return _favBox.containsKey(_favKey(productId, variantId));
    } catch (e) {
      throw CacheException(message: 'Failed to Check if Favourite');
    }
  }

  @override
  Stream<List<FavoriteItemModel>> watch() async* {
    log('=== WATCH CALLED ===');
    log('Box length: ${_favBox.length}');
    log('Box values: ${_favBox.values}');

    final current = _favBox.values
        .map(
          (e) => FavoriteItemModel.fromMap(Map<String, dynamic>.from(e as Map)),
        )
        .toList();

    log('Current items count: ${current.length}');
    yield current;

    yield* _favBox.watch().map((_) {
      final updated = _favBox.values
          .map(
            (e) =>
                FavoriteItemModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      log('Watch update - count: ${updated.length}');
      return updated;
    });
  }

  @override
  Future<void> addToOutBox(PendingOperation op) async {
    try {
      await _outBox.put(_outKey(op), op.toMap());
    } catch (e) {
      throw CacheException(message: 'Failed to Add Operation Pending');
    }
  }

  String _outKey(PendingOperation op) =>
      '${op.key}_${op.createdAt.millisecondsSinceEpoch}';

  @override
  Future<List<PendingOperation>> getOutBox() async {
    try {
      return _outBox.values
          .map(
            (e) =>
                PendingOperation.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to read Pending Operation');
    }
  }

  @override
  Future<void> clearOutBox(List<PendingOperation> ops) async {
    try {
      for (final op in ops) {
        await _outBox.delete(_outKey(op));
      }
    } catch (e) {
      throw CacheException(message: 'Failed to Delete Operation');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _favBox.clear();
      await _outBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear Local Storage');
    }
  }
}
