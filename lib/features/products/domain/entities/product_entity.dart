import 'package:equatable/equatable.dart';

enum ProductGender { men, kids }

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double finalPrice;
  final int discountPercentage;
  final bool hasDiscount;
  final List<String> imageUrls;
  final String categoryId;
  final ProductGender gender;
  final String brand;
  final List<String> tags;
  final List<String> availableSizes;
  final List<String> availableColors;
  final bool newArrival;
  final bool featured;
  final int stock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.finalPrice,
    required this.discountPercentage,
    required this.hasDiscount,
    required this.imageUrls,
    required this.categoryId,
    required this.gender,
    required this.brand,
    required this.tags,
    required this.availableSizes,
    required this.availableColors,
    required this.newArrival,
    required this.featured,
    required this.stock,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  /// ✅ Factory ذكي — بيحسب الحقول المشتقة تلقائيًا.
  /// استخدمه وقت **الكتابة** (Admin panel / Seeder).
  factory ProductEntity.priced({
    required String id,
    required String name,
    required String description,
    required double price,
    int discountPercentage = 0,
    required List<String> imageUrls,
    required String categoryId,
    required ProductGender gender,
    required String brand,
    List<String> tags = const [],
    required List<String> availableSizes,
    required List<String> availableColors,
    bool newArrival = false,
    bool featured = false,
    required int stock,
    double rating = 0.0,
    int reviewCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final safePercentage = (discountPercentage < 0 || discountPercentage > 100)
        ? 0
        : discountPercentage;

    final hasDisc = safePercentage > 0 && price > 0;
    final computedFinalPrice = hasDisc
        ? price * (1 - safePercentage / 100)
        : price;

    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      finalPrice: computedFinalPrice,
      discountPercentage: hasDisc ? safePercentage : 0,
      hasDiscount: hasDisc,
      imageUrls: imageUrls,
      categoryId: categoryId,
      gender: gender,
      brand: brand,
      tags: tags,
      availableSizes: availableSizes,
      availableColors: availableColors,
      newArrival: newArrival,
      featured: featured,
      stock: stock,
      rating: rating,
      reviewCount: reviewCount,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
    );
  }

  // ========== Helper Getters (UI-friendly) ==========

  /// القيمة الموفّرة بالجنيه
  double get discountAmount => price - finalPrice;

  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 5;
  String get mainImage => imageUrls.isNotEmpty ? imageUrls.first : '';
  bool get isMen => gender == ProductGender.men;
  bool get isKids => gender == ProductGender.kids;

  // ========== CopyWith ==========

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? finalPrice,
    int? discountPercentage,
    bool? hasDiscount,
    List<String>? imageUrls,
    String? categoryId,
    ProductGender? gender,
    String? brand,
    List<String>? tags,
    List<String>? availableSizes,
    List<String>? availableColors,
    bool? newArrival,
    bool? featured,
    int? stock,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      finalPrice: finalPrice ?? this.finalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      gender: gender ?? this.gender,
      brand: brand ?? this.brand,
      tags: tags ?? this.tags,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
      newArrival: newArrival ?? this.newArrival,
      featured: featured ?? this.featured,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    finalPrice,
    discountPercentage,
    hasDiscount,
    imageUrls,
    categoryId,
    gender,
    brand,
    tags,
    availableSizes,
    availableColors,
    newArrival,
    featured,
    stock,
    rating,
    reviewCount,
    createdAt,
    updatedAt,
  ];
}
