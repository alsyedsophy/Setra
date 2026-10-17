import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/favorites/data/models/favorite_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteItemModel>> getFavorites();
  Future<void> addFavourite(FavoriteItemModel item);
  Future<void> removeFavorite(String productId, {String? variantId});
  Future<void> mergeGuestFavorites(List<FavoriteItemModel> items);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoritesRemoteDataSourceImpl({
    required this._firestore,
    required this._auth,
  });

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException(message: 'Must Be Authenticated');
    }
    return uid;
  }

  CollectionReference get _favCollection =>
      _firestore.collection('users').doc(_uid).collection('favorites');

  String _docId(String pid, String? vid) =>
      vid == null ? pid : '${pid}_$vid';

  @override
  Future<List<FavoriteItemModel>> getFavorites() async {
    try {
      final snapshot = await _favCollection.get();
      return snapshot.docs
          .map(
            (doc) => FavoriteItemModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed To Get Favorites');
    }
  }

  @override
  Future<void> addFavourite(FavoriteItemModel item) async {
    try {
      final doc = _docId(item.productId, item.variantId);
      await _favCollection
          .doc(doc)
          .set(item.toFirestore(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to Add This Item');
    }
  }

  @override
  Future<void> removeFavorite(String productId, {String? variantId}) async {
    try {
      final doc = _docId(productId, variantId);
      await _favCollection.doc(doc).delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed To Remove Item');
    }
  }

  @override
  Future<void> mergeGuestFavorites(List<FavoriteItemModel> items) async {
    try {
      final batch = _firestore.batch();
      for (final item in items) {
        final doc = _docId(item.productId, item.variantId);
        final ref = _favCollection.doc(doc);
        batch.set(ref, item.toFirestore(), SetOptions(merge: true));
      }
      batch.commit();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed To Merge Guest Favorites',
      );
    }
  }
}