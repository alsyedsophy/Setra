import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/favorites/presentation/screens/favorites_screen.dart';

List<RouteBase> get favoritesRoute => [
      GoRoute(
        path: RoutePaths.favorites,
        name: RoutePaths.favoritesName,
        builder: (BuildContext context, GoRouterState state) =>
            const FavoritesScreen(),
      ),
    ];
