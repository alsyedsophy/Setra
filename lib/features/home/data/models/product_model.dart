import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.discountPrice,
    required super.imageUrls,
    required super.categoryId,
    required super.gender,
    required super.availableSizes,
    required super.availableColors,
    required super.newArrival,
    required super.featured,
    required super.brand,
    required super.stock,
    super.rating,
    super.reviewCount,
    super.tags,
    required super.createdAt,
  });

  /// Factory constructor للإنشاء من Firestore Document
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      discountPrice: data['discountPrice'] != null
          ? (data['discountPrice'] as num).toDouble()
          : null,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      // تحويل الـ Map الخاصة بالتصنيف إلى CategoryModel (الذي يمتد من CategoryEntity)
      categoryId: data['categoryId'] ?? '',
      gender: _parseProductGender(data['gender']),
      availableSizes: List<String>.from(data['availableSizes'] ?? []),
      availableColors: List<String>.from(data['availableColors'] ?? []),
      newArrival: data['newArrival'] ?? false,
      featured: data['featured'] ?? false,
      brand: data['brand'] ?? '',
      stock: (data['stock'] ?? 0).toInt(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: (data['reviewCount'] ?? 0).toInt(),
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// تحويل الـ Model إلى Map لحفظها في Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'gender': gender.name,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'newArrival': newArrival,
      'featured': featured,
      'brand': brand,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Factory constructor للتحويل من الـ Domain Entity
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discountPrice: entity.discountPrice,
      imageUrls: entity.imageUrls,
      categoryId: entity.categoryId,
      gender: entity.gender,
      availableSizes: entity.availableSizes,
      availableColors: entity.availableColors,
      newArrival: entity.newArrival,
      featured: entity.featured,
      brand: entity.brand,
      stock: entity.stock,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      tags: entity.tags,
      createdAt: entity.createdAt,
    );
  }

  /// Helper بسيط لتحويل الـ String القادم من الـ Backend إلى Enum
  static ProductGender _parseProductGender(String? genderStr) {
    switch (genderStr?.toLowerCase()) {
      case 'kids':
        return ProductGender.kids;
      case 'men':
      default:
        return ProductGender.men;
    }
  }
}
