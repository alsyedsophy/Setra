import 'package:equatable/equatable.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';

enum CategoryStatus { initial, loading, loaded, empty, error }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    CategoryEntity? selectedCategory,
    String? errorMessage,
    bool clearError = false,
    bool clearSelectedCategory = false,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory:
          clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isLoading => status == CategoryStatus.loading;
  bool get isLoaded => status == CategoryStatus.loaded;
  bool get isEmpty => status == CategoryStatus.empty;
  bool get isError => status == CategoryStatus.error;
  bool get isInitial => status == CategoryStatus.initial;

  @override
  List<Object?> get props => [status, categories, selectedCategory, errorMessage];
}