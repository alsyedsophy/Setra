import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/category/presentation/screens/category_screen.dart';
import 'package:setra/features/category/presentation/screens/products_category_screen.dart';

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
      return ProductsCategoryScreen(categoryId: categoryId);
    },
  ),
];
