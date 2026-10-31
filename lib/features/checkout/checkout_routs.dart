import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/dependency_injection/dependency_injection.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:setra/features/checkout/presentation/screens/checkout_screen.dart';

List<RouteBase> get checkoutRoutes => [
  GoRoute(
    path: RoutePaths.checkout,
    name: RoutePaths.checkoutName,
    builder: (context, state) => BlocProvider(
      create: (context) => getIt<CheckoutCubit>(),
      child: CheckoutScreen(),
    ),
  ),
];
