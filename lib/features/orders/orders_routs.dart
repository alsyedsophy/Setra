import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/cart/cart_injection.dart';
import 'package:setra/features/orders/presentation/cubits/order_details_cubit.dart';
import 'package:setra/features/orders/presentation/cubits/orders_cubit.dart';
import 'package:setra/features/orders/presentation/screens/order_details_screen.dart';
import 'package:setra/features/orders/presentation/screens/orders_screen.dart';

List<RouteBase> get ordersRoutes => [
  GoRoute(
    path: RoutePaths.orders,
    name: RoutePaths.ordersName,
    builder: (context, state) => BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: OrdersScreen(),
    ),
  ),
  GoRoute(
    path: RoutePaths.orderDetails,
    name: RoutePaths.ordersDetailsName,
    builder: (context, state) => BlocProvider(
      create: (context) => getIt<OrderDetailsCubit>(),
      child: OrderDetailsScreen(),
    ),
  ),
];
