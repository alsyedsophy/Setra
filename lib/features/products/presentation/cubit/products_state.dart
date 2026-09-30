import 'package:equatable/equatable.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<ProductEntity> products;
  final List<ProductEntity> relatedProducts;
  final ProductFilter filter;
  final ProductSort sort;
  final String? errorMessage;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.relatedProducts = const [],
    this.filter = const ProductFilter(),
    this.sort = const ProductSort(),
    this.errorMessage,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductEntity>? products,
    List<ProductEntity>? relatedProducts,
    ProductFilter? filter,
    ProductSort? sort,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasActiveFilters => filter.hasActiveFilters;
  int get activeFilterCount => filter.activeFilterCount;

  @override
  List<Object?> get props => [
    status,
    products,
    relatedProducts,
    filter,
    sort,
    errorMessage,
  ];
}
