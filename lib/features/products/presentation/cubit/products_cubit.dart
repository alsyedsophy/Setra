import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';
import 'package:setra/features/products/domain/usecases/get_products_use_case.dart';
import 'package:setra/features/products/domain/usecases/get_related_products_use_case.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProducts;
  final GetRelatedProductsUseCase _getRelatedProducts;

  ProductsCubit(this._getProducts, this._getRelatedProducts)
    : super(const ProductsState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading, clearError: true));

    final result = await _getProducts(filter: state.filter, sort: state.sort);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(status: ProductsStatus.success, products: products),
      ),
    );
  }

  Future<void> refresh() => loadProducts();

  Future<void> applyFilter(ProductFilter filter) async {
    emit(state.copyWith(filter: filter));
    await loadProducts();
  }

  Future<void> applySort(ProductSort sort) async {
    emit(state.copyWith(sort: sort));
    await loadProducts();
  }

  Future<void> clearFilters() async {
    emit(
      state.copyWith(filter: const ProductFilter(), sort: const ProductSort()),
    );
    await loadProducts();
  }

  Future<void> removeFilter(ProductFilter newFilter) async {
    await applyFilter(newFilter);
  }

  Future<void> getRelatedProducts(String productId, {int limit = 10}) async {
    final result = await _getRelatedProducts(productId, limit: limit);

    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (related) {
        emit(state.copyWith(relatedProducts: related));
      },
    );
  }
}
