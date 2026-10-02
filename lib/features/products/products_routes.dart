import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/routing.dart';

List<RouteBase> get productsRoute => [
  GoRoute(
    path: RoutePaths.products,
    name: RoutePaths.productsName,
    builder: (context, state) => _ProductsPlaceholderScreen(),
  ),
  GoRoute(
    path: RoutePaths.productsDetails,
    name: RoutePaths.productsDetailsName,
    builder: (context, state) {
      final productId = state.pathParameters['productId']!;
      return _ProductsDetailPlaceholderScreen(productId: productId);
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
