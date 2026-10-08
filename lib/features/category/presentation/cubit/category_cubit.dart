import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/category/domain/usecases/category_usecases.dart';
import 'package:setra/features/category/domain/usecases/get_categories_for_gender_use_case.dart';
import 'package:setra/features/category/domain/usecases/get_featured_category.dart';
import 'package:setra/features/category/presentation/cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required this._getCategoriesUseCase,
    required this._getCategoryByIdUseCase,
    required this._getFeaturedCategoriesUseCase,
    required this._getCategoriesForGenderUseCase,
  }) : super(const CategoryState());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetCategoryByIdUseCase _getCategoryByIdUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;
  final GetCategoriesForGenderUseCase _getCategoriesForGenderUseCase;

  Future<void> loadCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading, clearError: true));

    final result = await _getCategoriesUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) {
        if (categories.isEmpty) {
          emit(
            state.copyWith(
              status: CategoryStatus.empty,
              categories: categories,
              clearError: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CategoryStatus.loaded,
              categories: categories,
              clearError: true,
            ),
          );
        }
      },
    );
  }

  Future<void> loadFeaturedCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading, clearError: true));

    final result = await _getFeaturedCategoriesUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) {
        if (categories.isEmpty) {
          emit(
            state.copyWith(
              status: CategoryStatus.empty,
              categories: categories,
              clearError: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CategoryStatus.loaded,
              categories: categories,
              clearError: true,
            ),
          );
        }
      },
    );
  }

  Future<void> loadCategoryById(String categoryId) async {
    emit(state.copyWith(status: CategoryStatus.loading, clearError: true));

    final result = await _getCategoryByIdUseCase(categoryId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (category) => emit(
        state.copyWith(
          status: CategoryStatus.loaded,
          selectedCategory: category,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> loadCategoriesForGender(String gender) async {
    emit(state.copyWith(status: CategoryStatus.loading, clearError: true));

    final result = await _getCategoriesForGenderUseCase(gender);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> refresh() => loadCategories();

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
