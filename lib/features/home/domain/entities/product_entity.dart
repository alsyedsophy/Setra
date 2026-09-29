import 'package:equatable/equatable.dart';

enum ProductGender { men, kids }

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice; // null = مفيش خصم
  final List<String> imageUrls;
  final String categoryId;
  final ProductGender gender;
  final List<String> availableSizes; // ["S", "M", "L", "XL"]
  final List<String> availableColors; // ["Black", "White", "Navy"]
  final bool newArrival;
  final bool featured;
  final String brand;
  final int stock;
  final double rating; // من 0 إلى 5
  final int reviewCount;
  final List<String> tags; // ["summer", "cotton", "casual"]
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.imageUrls,
    required this.categoryId,
    required this.gender,
    required this.availableSizes,
    required this.availableColors,
    required this.newArrival,
    required this.featured,
    required this.brand,
    required this.stock,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    required this.createdAt,
  });

  // ========== Helper Getters ==========

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  double get finalPrice => hasDiscount ? discountPrice! : price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((price - discountPrice!) / price) * 100).round();
  }

  bool get isInStock => stock > 0;

  bool get isLowStock => stock > 0 && stock <= 5;

  String get mainImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  // ========== CopyWith ==========

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    List<String>? imageUrls,
    String? categoryId,
    ProductGender? gender,
    List<String>? availableSizes,
    List<String>? availableColors,
    bool? newArrival,
    bool? featured,
    String? brand,
    int? stock,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      gender: gender ?? this.gender,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
      newArrival: newArrival ?? this.newArrival,
      featured: featured ?? this.featured,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    discountPrice,
    imageUrls,
    categoryId,
    gender,
    availableSizes,
    availableColors,
    newArrival,
    featured,
    brand,
    stock,
    rating,
    reviewCount,
    tags,
    createdAt,
  ];
}
