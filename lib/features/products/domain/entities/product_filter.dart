import 'package:equatable/equatable.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class ProductFilter extends Equatable {
  final String? categoryId;
  final ProductGender? gender;
  final List<String> tags;
  final double? minPrice;
  final double? maxPrice;
  final bool? inStockOnly;
  final bool? featuredOnly;
  final bool? newArrivalOnly;
  final bool? hasDiscountOnly;
  final String? brand;
  final List<String> sizes;
  final List<String> colors;

  const ProductFilter({
    this.categoryId,
    this.gender,
    this.tags = const [],
    this.minPrice,
    this.maxPrice,
    this.inStockOnly,
    this.featuredOnly,
    this.newArrivalOnly,
    this.hasDiscountOnly,
    this.brand,
    this.sizes = const [],
    this.colors = const [],
  });

  ProductFilter copyWith({
    String? categoryId,
    ProductGender? gender,
    List<String>? tags,
    double? minPrice,
    double? maxPrice,
    bool? inStockOnly,
    bool? featuredOnly,
    bool? newArrivalOnly,
    bool? hasDiscountOnly,
    String? brand,
    List<String>? sizes,
    List<String>? colors,
    bool clearCategory = false,
    bool clearGender = false,
    bool clearTags = false,
    bool clearPriceRange = false,
    bool clearInStock = false,
    bool clearFeatured = false,
    bool clearNewArrival = false,
    bool clearHasDiscount = false,
    bool clearBrand = false,
    bool clearSizes = false,
    bool clearColors = false,
  }) {
    return ProductFilter(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      gender: clearGender ? null : (gender ?? this.gender),
      tags: clearTags ? const [] : (tags ?? this.tags),
      minPrice: clearPriceRange ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceRange ? null : (maxPrice ?? this.maxPrice),
      inStockOnly: clearInStock ? null : (inStockOnly ?? this.inStockOnly),
      featuredOnly: clearFeatured ? null : (featuredOnly ?? this.featuredOnly),
      newArrivalOnly: clearNewArrival
          ? null
          : (newArrivalOnly ?? this.newArrivalOnly),
      hasDiscountOnly: clearHasDiscount
          ? null
          : (hasDiscountOnly ?? this.hasDiscountOnly),
      brand: clearBrand ? null : (brand ?? this.brand),
      sizes: clearSizes ? const [] : (sizes ?? this.sizes),
      colors: clearColors ? const [] : (colors ?? this.colors),
    );
  }

  bool get hasActiveFilters =>
      categoryId != null ||
      gender != null ||
      tags.isNotEmpty ||
      minPrice != null ||
      maxPrice != null ||
      inStockOnly == true ||
      featuredOnly == true ||
      newArrivalOnly == true ||
      hasDiscountOnly == true ||
      brand != null ||
      sizes.isNotEmpty ||
      colors.isNotEmpty;

  int get activeFilterCount {
    int count = 0;
    if (categoryId != null) count++;
    if (gender != null) count++;
    if (tags.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (inStockOnly == true) count++;
    if (featuredOnly == true) count++;
    if (newArrivalOnly == true) count++;
    if (hasDiscountOnly == true) count++;
    if (brand != null) count++;
    if (sizes.isNotEmpty) count++;
    if (colors.isNotEmpty) count++;
    return count;
  }

  ProductFilter clear() => const ProductFilter();

  @override
  List<Object?> get props => [
    categoryId,
    gender,
    tags,
    minPrice,
    maxPrice,
    inStockOnly,
    featuredOnly,
    newArrivalOnly,
    hasDiscountOnly,
    brand,
    sizes,
    colors,
  ];
}
