import 'package:equatable/equatable.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';
import 'package:setra/features/home/domain/entities/category_entity.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final List<ProductEntity> newArrival;
  final List<ProductEntity> featured;
  final String? errorMessage;
  final String? selectedCategoryId; // لتتبع القسم المحدد حالياً في الـ UI

  const HomeState({
    this.status = HomeStatus.initial,
    this.banners = const [],
    this.categories = const [],
    this.products = const [],
    this.newArrival = const [],
    this.featured = const [],
    this.errorMessage,
    this.selectedCategoryId,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<BannerEntity>? banners,
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    List<ProductEntity>? newArrival,
    List<ProductEntity>? featured,
    String? errorMessage,
    String? selectedCategoryId,
  }) {
    return HomeState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      newArrival: newArrival ?? this.newArrival,
      featured: featured ?? this.featured,
      products: products ?? this.products,
      errorMessage: errorMessage,
      selectedCategoryId: selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    banners,
    categories,
    products,
    newArrival,
    featured,
    errorMessage,
    selectedCategoryId,
  ];
}
