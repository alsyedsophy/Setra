import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/core/errors/exceptions.dart'; // تأكد من استيراد ملف الـ Exceptions الخاص بك
import 'package:setra/features/products/data/models/product_model.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    ProductFilter? filter,
    ProductSort? sort,
  });

  Future<ProductModel> getProductById(String id);

  Future<List<ProductModel>> getRelatedProducts(
    String productId, {
    int limit = 10,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final FirebaseFirestore firestore;

  static const String _collection = 'products';

  ProductsRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getProducts({
    ProductFilter? filter,
    ProductSort? sort,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection(_collection);

      // ============ Apply Filters ============
      if (filter != null) {
        query = _applyFilter(query, filter);
      }

      // ============ Apply Sort ============
      if (sort != null) {
        query = query.orderBy(
          sort.option.firestoreField,
          descending: sort.option.isDescending,
        );
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      // ============ Execute ============
      final snapshot = await query.get();
      var products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), docId: doc.id))
          .toList();

      // ============ Client-side filtering (Firestore limitations) ============
      if (filter != null) {
        if (filter.sizes.isNotEmpty) {
          products = products
              .where((p) => p.availableSizes.any(filter.sizes.contains))
              .toList();
        }
        if (filter.colors.isNotEmpty) {
          products = products
              .where((p) => p.availableColors.any(filter.colors.contains))
              .toList();
        }
      }

      return products;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw ServerException(message: 'Product with id "$id" was not found');
      }
      return ProductModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getRelatedProducts(
    String productId, {
    int limit = 10,
  }) async {
    try {
      // 1. اجلب المنتج الأصلي
      final original = await getProductById(productId);

      final relatedMap = <String, ProductModel>{};

      // 2. منتجات نفس الـ category + نفس الـ gender
      final categorySnapshot = await firestore
          .collection(_collection)
          .where('categoryId', isEqualTo: original.categoryId)
          .where('gender', isEqualTo: original.gender.name)
          .orderBy('createdAt', descending: true)
          .limit(limit + 1)
          .get();

      for (final doc in categorySnapshot.docs) {
        final product = ProductModel.fromFirestore(doc.data(), docId: doc.id);
        if (product.id != productId) {
          relatedMap[product.id] = product;
        }
      }

      // 3. Fallback: نفس الـ brand لو النتيجة أقل من المطلوب
      if (relatedMap.length < limit && original.brand.trim().isNotEmpty) {
        final brandSnapshot = await firestore
            .collection(_collection)
            .where('brand', isEqualTo: original.brand)
            .where('gender', isEqualTo: original.gender.name)
            .orderBy('createdAt', descending: true)
            .limit(limit * 2)
            .get();

        for (final doc in brandSnapshot.docs) {
          final product = ProductModel.fromFirestore(doc.data(), docId: doc.id);
          if (product.id != productId && !relatedMap.containsKey(product.id)) {
            relatedMap[product.id] = product;
          }
          if (relatedMap.length >= limit) break;
        }
      }

      return relatedMap.values.take(limit).toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ====================== Helper ===================

  Query<Map<String, dynamic>> _applyFilter(
    Query<Map<String, dynamic>> query,
    ProductFilter filter,
  ) {
    if (filter.categoryId != null) {
      query = query.where('categoryId', isEqualTo: filter.categoryId);
    }
    if (filter.gender != null) {
      query = query.where('gender', isEqualTo: filter.gender!.name);
    }
    if (filter.brand != null && filter.brand!.trim().isNotEmpty) {
      query = query.where('brand', isEqualTo: filter.brand);
    }
    if (filter.minPrice != null) {
      query = query.where(
        'finalPrice',
        isGreaterThanOrEqualTo: filter.minPrice,
      );
    }
    if (filter.maxPrice != null) {
      query = query.where('finalPrice', isLessThanOrEqualTo: filter.maxPrice);
    }
    if (filter.inStockOnly == true) {
      query = query.where('stock', isGreaterThan: 0);
    }
    if (filter.featuredOnly == true) {
      query = query.where('featured', isEqualTo: true);
    }
    if (filter.newArrivalOnly == true) {
      query = query.where('newArrival', isEqualTo: true);
    }
    if (filter.hasDiscountOnly == true) {
      query = query.where('hasDiscount', isEqualTo: true);
    }

    if (filter.tags.isNotEmpty) {
      final tags = filter.tags.take(10).toList(); // Firestore max = 10
      query = query.where('tags', arrayContainsAny: tags);
    }
    return query;
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
