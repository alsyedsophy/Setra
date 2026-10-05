import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/dependency_injection/service_locator.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/products_domain.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/screens/Product_details.dart';
import 'package:setra/features/products/presentation/screens/products_category_screen.dart';

List<RouteBase> get productsRoute => [
  GoRoute(
    path: RoutePaths.products,
    name: RoutePaths.productsName,
    builder: (context, state) {
      final categoryId = state.extra! as String;
      return BlocProvider(
        create: (context) =>
            getIt<ProductsCubit>()
              ..applyFilter(ProductFilter(categoryId: categoryId)),
        child: ProductsCategoryScreen(categoryId: categoryId),
      );
    },
  ),
  GoRoute(
    path: RoutePaths.productsDetails,
    name: RoutePaths.productsDetailsName,
    builder: (context, state) {
      final productEntity = state.extra as ProductEntity;
      return ProductDetails(productEntity: productEntity);
    },
  ),
];

/// Placeholder screen for category list - replace with actual screen when UI is implemented
class _ProductsPlaceholderScreen extends StatelessWidget {
  const _ProductsPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(
        child: Text('Products List Screen - UI Not Implemented'),
      ),
    );
  }
}

/// Placeholder screen for Products detail - replace with actual screen when UI is implemented
class _ProductsDetailPlaceholderScreen extends StatelessWidget {
  const _ProductsDetailPlaceholderScreen({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products Detail')),
      body: Center(
        child: Text('Products Detail for ID: $productId - UI Not Implemented'),
      ),
    );
  }
}
