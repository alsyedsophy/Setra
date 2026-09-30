import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.finalPrice,
    required super.discountPercentage,
    required super.hasDiscount,
    required super.imageUrls,
    required super.categoryId,
    required super.gender,
    required super.brand,
    required super.tags,
    required super.availableSizes,
    required super.availableColors,
    required super.newArrival,
    required super.featured,
    required super.stock,
    super.rating,
    super.reviewCount,
    required super.createdAt,
    super.updatedAt,
  });

  factory ProductModel.fromFirestore(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    return ProductModel(
      id: (map['id'] as String?) ?? docId ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: _toDouble(map['price']),
      finalPrice: _toDouble(map['finalPrice']),
      discountPercentage: _toInt(map['discountPercentage']),
      hasDiscount: map['hasDiscount'] as bool? ?? false,
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? const []),
      categoryId: map['categoryId'] as String? ?? '',
      gender: _parseGender(map['gender'] as String?),
      brand: map['brand'] as String? ?? '',
      tags: List<String>.from(map['tags'] as List? ?? const []),
      availableSizes: List<String>.from(
        map['availableSizes'] as List? ?? const [],
      ),
      availableColors: List<String>.from(
        map['availableColors'] as List? ?? const [],
      ),
      newArrival: map['newArrival'] as bool? ?? false,
      featured: map['featured'] as bool? ?? false,
      stock: _toInt(map['stock']),
      rating: _toDouble(map['rating']),
      reviewCount: _toInt(map['reviewCount']),
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'finalPrice': finalPrice,
      'discountPercentage': discountPercentage,
      'hasDiscount': hasDiscount,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'gender': gender.name,
      'brand': brand,
      'tags': tags,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'newArrival': newArrival,
      'featured': featured,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      finalPrice: entity.finalPrice,
      discountPercentage: entity.discountPercentage,
      hasDiscount: entity.hasDiscount,
      imageUrls: entity.imageUrls,
      categoryId: entity.categoryId,
      gender: entity.gender,
      brand: entity.brand,
      tags: entity.tags,
      availableSizes: entity.availableSizes,
      availableColors: entity.availableColors,
      newArrival: entity.newArrival,
      featured: entity.featured,
      stock: entity.stock,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // ============ Parsing Helpers ============

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static ProductGender _parseGender(String? value) {
    switch (value) {
      case 'men':
        return ProductGender.men;
      case 'kids':
        return ProductGender.kids;
      default:
        return ProductGender.men;
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
