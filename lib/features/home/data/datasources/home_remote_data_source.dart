import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/home/data/models/banner_model.dart';
import 'package:setra/features/home/data/models/category_model.dart';
import 'package:setra/features/products/data/models/product_model.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

abstract class HomeRemoteDataSource {
  Future<List<BannerModel>> getBanners();
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> newArrivalProducts();
  Future<List<ProductModel>> featuredProducts();
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> getProductsByTag(String tag);
  Future<List<ProductModel>> getProductsByGender(ProductGender gender);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore _firestore;

  HomeRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final snapshot = await _firestore
          .collection('banners')
          .orderBy('displayOrder')
          .get();
      return snapshot.docs
          .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<ProductModel>> featuredProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .where('featured', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<ProductModel>> newArrivalProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .where('newArrival', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByTag(String tag) async {
    try {
      // استعلام Firestore للبحث داخل مصفوفة الـ tags
      final snapshot = await _firestore
          .collection('products')
          .where('tags', arrayContains: tag)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByGender(ProductGender gender) async {
    try {
      // تحويل الـ Enum إلى String لمطابقته مع المخزن في قاعدة البيانات
      final snapshot = await _firestore
          .collection('products')
          .where('gender', isEqualTo: gender.name)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  Exceptions _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AuthException(message: 'Permission denied');
      case 'unavailable':
        return NetworkException(message: 'No internet connection');
      case 'not-found':
        return ServerException(message: 'Document not found');
      default:
        return ServerException(message: e.message ?? 'Server error');
    }
  }
}
