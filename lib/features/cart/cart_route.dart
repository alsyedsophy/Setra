import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/cart/presentation/screens/cart_screen.dart';

List<RouteBase> get cartRoutes => [
  GoRoute(
    path: RoutePaths.cart,
    name: RoutePaths.cartName,
    builder: (context, state) => CartScreen(),
  ),
];
