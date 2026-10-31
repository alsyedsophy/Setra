import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/dependency_injection/service_locator.dart';
import 'package:setra/core/routing/stream_listenable.dart';
import 'package:setra/features/address/address_route.dart';
import 'package:setra/features/auth/auth_routes.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:setra/features/cart/cart_route.dart';
import 'package:setra/features/category/category_routes.dart';
import 'package:setra/features/checkout/checkout_routs.dart';
import 'package:setra/features/favorites/favorites_routes.dart';
import 'package:setra/features/home/home_routes.dart';
import 'package:setra/features/orders/orders_routs.dart';
import 'package:setra/features/products/products_routes.dart';

import 'route_error_screen.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    final authCubit = getIt<AuthCubit>();

    return GoRouter(
      initialLocation: RoutePaths.home,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        ...homeRoutes,
        ...categoryRoutes,
        ...productsRoute,
        ...favoritesRoute,
        ...authRoutes,
        ...cartRoutes,
        ...addressRoutes,
        ...checkoutRoutes,
        ...ordersRoutes,
      ],
      refreshListenable: StreamListenable(authCubit.stream),
      errorBuilder: (BuildContext context, GoRouterState state) =>
          RouteErrorScreen(message: state.error?.message),

      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;
        log('Current Location: $location | AuthStatus: ${authState.status}');

        final bool isSplash = location == RoutePaths.splash;
        final bool isAuthRoute =
            location == RoutePaths.login ||
            location == RoutePaths.register ||
            location == RoutePaths.forgetPasswod;
        final bool isVerifyRoute = location == RoutePaths.verifyEmail;

        final bool isHomeRoute =
            location == RoutePaths.home ||
            location == RoutePaths.favorites ||
            location == RoutePaths.categoryProducts ||
            location == RoutePaths.products ||
            location == RoutePaths.productsGender ||
            location == RoutePaths.productsDetails;

        final isProtectedRoute =
            location == RoutePaths.addresses ||
            location == RoutePaths.addressForm ||
            location == RoutePaths.cart ||
            location == RoutePaths.checkout ||
            location == RoutePaths.orders ||
            location == RoutePaths.orderDetails;

        if (authState.status == AuthStatus.initial ||
            (authState.status == AuthStatus.loading && isSplash)) {
          return isSplash ? null : RoutePaths.splash;
        }

        if (authState.status == AuthStatus.authenticated) {
          if (isSplash || isAuthRoute || isVerifyRoute) {
            return RoutePaths.home;
          }
          return null;
        }

        if (authState.status == AuthStatus.unverified) {
          if (isVerifyRoute) {
            return null;
          }
          return RoutePaths.verifyEmail;
        }

        if (authState.status == AuthStatus.unauthenticated ||
            authState.status == AuthStatus.failure) {
          if (isAuthRoute || isHomeRoute) return null;
          if (isProtectedRoute && !isHomeRoute) {
            return RoutePaths.login;
          }
        }

        return null;
      },
    );
  }
}
