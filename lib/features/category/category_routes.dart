import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/category/presentation/screens/category_screen.dart';

List<RouteBase> get categoryRoutes => [
  GoRoute(
    path: RoutePaths.category,
    name: RoutePaths.categoryName,
    builder: (BuildContext context, GoRouterState state) {
      final gender = state.extra as String;
      return CategoryScreen(gender: gender);
    },
  ),
  GoRoute(
    path: RoutePaths.categoryDetail,
    name: RoutePaths.categoryDetailName,
    builder: (BuildContext context, GoRouterState state) {
      final categoryId = state.pathParameters['categoryId']!;
      return _CategoryDetailPlaceholderScreen(categoryId: categoryId);
    },
  ),
];

/// Placeholder screen for category list - replace with actual screen when UI is implemented
class _CategoryPlaceholderScreen extends StatelessWidget {
  const _CategoryPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: const Center(
        child: Text('Category List Screen - UI Not Implemented'),
      ),
    );
  }
}

/// Placeholder screen for category detail - replace with actual screen when UI is implemented
class _CategoryDetailPlaceholderScreen extends StatelessWidget {
  const _CategoryDetailPlaceholderScreen({required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category Detail')),
      body: Center(
        child: Text('Category Detail for ID: $categoryId - UI Not Implemented'),
      ),
    );
  }
}
