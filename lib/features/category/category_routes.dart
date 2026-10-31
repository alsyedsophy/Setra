import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/dependency_injection/service_locator.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/category/presentation/screens/products_category_screen.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';

List<RouteBase> get categoryRoutes => [
  GoRoute(
    path: RoutePaths.categoryProducts,
    name: RoutePaths.categoryProductsName,
    builder: (context, state) {
      final categoryId = state.extra! as String;
      return BlocProvider(
        create: (context) =>
            getIt<ProductsCubit>()
              ..applyFilter(ProductFilter(categoryId: categoryId)),
        child: CategoryProductsScreen(categoryId: categoryId),
      );
    },
  ),

  // GoRoute(
  //   path: RoutePaths.category,
  //   name: RoutePaths.categoryName,
  //   builder: (BuildContext context, GoRouterState state) {
  //     final categoryId = state.extra as String;
  //     return CategoryProductsScreen(categoryId: categoryId);
  //   },
  // ),
];
