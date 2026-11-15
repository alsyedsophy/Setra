import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/route_paths.dart';
// import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.w_20,
        vertical: AppSpacing.h_10,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.onSecondary,
        border: Border.all(color: context.colorScheme.primary, width: 1),
        borderRadius: AppSpacing.r_10.rAll,
      ),
      child: Text('Logout'),
    ).onTap(() async {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        context.goNamed(RoutePaths.homeName);
      }
    });
  }
}
