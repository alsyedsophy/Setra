import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/dependency_injection/service_locator.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/products/presentation/screens/products_gender_screen.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/screens/Product_details.dart';
import 'package:setra/features/products/presentation/screens/products_list_screen.dart';

List<RouteBase> get productsRoute => [
  GoRoute(
    path: RoutePaths.products,
    name: RoutePaths.productsName,
    builder: (context, state) => BlocProvider.value(
      value: getIt<ProductsCubit>()..loadProducts(),
      child: ProductsListScreen(),
    ),
  ),
  GoRoute(
    path: RoutePaths.productsGender,
    name: RoutePaths.productsGenderName,
    builder: (BuildContext context, GoRouterState state) {
      final gender = state.extra as String;
      return ProductsGenderScreen(gender: gender);
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
