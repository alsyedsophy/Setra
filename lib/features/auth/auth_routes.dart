import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:setra/features/auth/presentation/screens/login_screen.dart';
import 'package:setra/features/auth/presentation/screens/register_screen.dart';
import 'package:setra/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/features/auth/presentation/screens/verify_email_screen.dart';

List<RouteBase> get authRoutes => [
  GoRoute(
    path: RoutePaths.splash,
    name: RoutePaths.splashName,
    builder: (BuildContext context, GoRouterState state) =>
        const SplashScreen(),
  ),
  GoRoute(
    path: RoutePaths.login,
    name: RoutePaths.loginName,
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: RoutePaths.register,
    name: RoutePaths.registerName,
    builder: (context, state) => RegisterScreen(),
  ),
  GoRoute(
    path: RoutePaths.verifyEmail,
    name: RoutePaths.verifyEmailName,
    builder: (context, state) => VerifyEmailScreen(),
  ),
  GoRoute(
    path: RoutePaths.forgetPasswod,
    name: RoutePaths.forgetPasswodName,
    builder: (context, state) => ForgetPasswordScreen(),
  ),
];
