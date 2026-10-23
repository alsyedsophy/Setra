import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/home/presentation/screens/home_screen.dart';

List<RouteBase> get homeRoutes => [
  GoRoute(
    path: RoutePaths.home,
    name: RoutePaths.homeName,
    builder: (BuildContext context, GoRouterState state) => HomeScreen(),
  ),
];
