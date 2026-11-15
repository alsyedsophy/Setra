import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/cart/cart_injection.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:setra/features/profile/presentation/screens/profile_details_screen.dart';
import 'package:setra/features/profile/presentation/screens/profile_screen.dart';
import 'package:setra/features/profile/presentation/screens/update_profile_screen.dart';

RouteBase get profileRoutes => ShellRoute(
  builder: (context, state, child) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getProfile(),
      child: child,
    );
  },
  routes: [
    GoRoute(
      path: RoutePaths.profile,
      name: RoutePaths.profileName, // ← مهم جدًا
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: RoutePaths.profileDetails,
      name: RoutePaths.profileDetailsName, // ← مهم
      builder: (context, state) {
        final profile = state.extra as ProfileEntity;
        return ProfileDetailsScreen(profile: profile);
      },
    ),
    GoRoute(
      path: RoutePaths.profileUpdate,
      name: RoutePaths.profileUpdateName, // ← مهم
      builder: (context, state) {
        final profile = state.extra as ProfileEntity;
        return UpdateProfileScreen(profile: profile);
      },
    ),
  ],
);
