import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/category/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<CategoryModel>> getFeaturedCategories();

  Future<CategoryModel> getCategoryById(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  static const String _collection = 'categories';
  static const int _defaultLimit = 100; // safety net

  CategoryRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder', descending: false)
          .limit(_defaultLimit)
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    } on StateError catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getFeaturedCategories() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .orderBy('displayOrder', descending: false)
          .limit(_defaultLimit)
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    } on StateError catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw ServerException(message: 'Category with id "$id" was not found');
      }
      return CategoryModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ============ Error Mapping ============

  Exceptions _mapFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
      case 'network-request-failed':
      case 'deadline-exceeded':
        return NetworkException(message: e.message ?? 'No internet connection');
      case 'permission-denied':
      case 'unauthenticated':
        return AuthException(message: e.message ?? 'Permission denied');
      case 'not-found':
        return ServerException(message: e.message ?? 'Resource not found');
      case 'failed-precondition':
        return ServerException(
          message: e.message ?? 'Query failed — check Firestore indexes',
        );
      case 'cancelled':
        return NetworkException(message: 'Request cancelled');
      default:
        return ServerException(message: e.message ?? 'Server error');
    }
  }
}
