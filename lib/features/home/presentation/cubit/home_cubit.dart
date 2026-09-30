import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/home/domain/usecases/get_banners_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_featured_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_new_arrival_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_by_category_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_by_gender_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_by_tags_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_use_case.dart';
import 'package:setra/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetBannersUseCase _getBannersUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final GetNewArrivalUseCase _getNewArrivalUseCase;
  final GetFeaturedUseCase _getFeaturedUseCase;
  final GetProductsByGenderUseCase _getProductsByGenderUseCase;
  final GetProductsByTagsUseCase _getProductsByTagsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  HomeCubit({
    required GetBannersUseCase getBannersUseCase,
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetNewArrivalUseCase getNewArrivalUseCase,
    required GetFeaturedUseCase getFeaturedUseCase,
    required GetProductsByGenderUseCase getProductsByGenderUseCase,
    required GetProductsByTagsUseCase getProductsByTagsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _getBannersUseCase = getBannersUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _getProductsUseCase = getProductsUseCase,
       _getNewArrivalUseCase = getNewArrivalUseCase,
       _getFeaturedUseCase = getFeaturedUseCase,
       _getProductsByGenderUseCase = getProductsByGenderUseCase,
       _getProductsByTagsUseCase = getProductsByTagsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final bannersResult = await _getBannersUseCase();
    final categoriesResult = await _getCategoriesUseCase();
    final products = await _getProductsUseCase();

    final List<Exception> failures = [];

    bannersResult.fold(
      (failure) => failures.add(Exception(failure.message)),
      (banners) => emit(state.copyWith(banners: banners)),
    );

    categoriesResult.fold(
      (failure) => failures.add(Exception(failure.message)),
      (categories) => emit(state.copyWith(categories: categories)),
    );

    products.fold(
      (failure) => failures.add(Exception(failure.message)),
      (products) => emit(state.copyWith(products: products)),
    );

    if (failures.isNotEmpty) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: failures.map((e) => e.toString()).join(', '),
        ),
      );
    } else {
      emit(state.copyWith(status: HomeStatus.loaded, errorMessage: null));
    }
  }

  Future<void> loadNewArrival() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getNewArrivalUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (newArrival) => emit(
        state.copyWith(status: HomeStatus.loaded, newArrival: newArrival),
      ),
    );
  }

  Future<void> loadFeatured() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getFeaturedUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (featured) =>
          emit(state.copyWith(status: HomeStatus.loaded, featured: featured)),
    );
  }

  Future<void> loadBanner() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getBannersUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (banners) =>
          emit(state.copyWith(status: HomeStatus.loaded, banners: banners)),
    );
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getProductsByCategoryUseCase(categoryId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (products) =>
          emit(state.copyWith(status: HomeStatus.loaded, products: products)),
    );
  }

  Future<void> loadProductsByGender(ProductGender gender) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getProductsByGenderUseCase(gender);

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (products) =>
          emit(state.copyWith(status: HomeStatus.loaded, products: products)),
    );
  }

  Future<void> loadProductsByTags(String tag) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getProductsByTagsUseCase(tag);

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (products) =>
          emit(state.copyWith(status: HomeStatus.loaded, products: products)),
    );
  }

  void clearError() {
    log("Delete Dialog");
    emit(state.copyWith(status: HomeStatus.loaded, errorMessage: ""));
  }
}
