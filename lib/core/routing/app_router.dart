import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/dependency_injection/service_locator.dart';
import 'package:setra/core/routing/stream_listenable.dart';

import 'route_error_screen.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    // final authCubit = getIt<AuthCubit>();
    return GoRouter(
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      // refreshListenable: StreamListenable(authCubit.stream),
      routes: <RouteBase>[
        // ...authRoutes,
        // GoRoute(
        //   path: RoutePaths.home,
        //   name: RoutePaths.homeName,
        //   builder: (BuildContext context, GoRouterState state) => HomeScreen(),
        // ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) =>
          RouteErrorScreen(message: state.error?.message),
      redirect: (context, state) {
        // final authState = authCubit.state;
        final location = state.matchedLocation;
        log(location);
        final bool isSplash = location == RoutePaths.splash;
        final bool isAuthRoute =
            location == RoutePaths.login || location == RoutePaths.register;

        // if (authState.status == AuthStatus.initial) {
        //   return isSplash ? null : RoutePaths.splash;
        // }

        // if (authState.status == AuthStatus.authenticated) {
        //   if (isSplash || isAuthRoute) {
        //     return RoutePaths.home;
        //   }
        //   return null;
        // }

        // if (authState.status == AuthStatus.unauthenticated) {
        //   if (isAuthRoute) {
        //     return null;
        //   }
        //   return RoutePaths.login;
        // }

        return null;
      },
    );
  }
}
