import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({super.key});

  Future<void> _onProfileTap(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    Scaffold.of(context).closeDrawer();
    await Future.delayed(const Duration(milliseconds: 260));

    if (!context.mounted) return;
    if (authCubit.state.user != null) {
      context.pushNamed(RoutePaths.profileName);
      return;
    }
    await authCubit.checkCurrentUser();

    if (!context.mounted) return;

    log('================== user = ${authCubit.state.user} ================');

    if (authCubit.state.user != null) {
      context.pushNamed(RoutePaths.profileName);
      return;
    } else {
      _showLoginRequiredDialog(context);
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to sign in to access your profile.'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                if (dialogContext.mounted) {
                  dialogContext.goNamed(RoutePaths.loginName);
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  // void _closeDrawerAndGo(
  //   BuildContext context,
  //   String routeName, {
  //   Object? extra,
  // }) {
  //   Navigator.of(context).pop();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!context.mounted) return;
  //     context.goNamed(routeName, extra: extra);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: context.colorScheme.primary,
      width: AppSpacing.w_256,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: AppSpacing.h_180,
            child: DrawerHeader(
              decoration: BoxDecoration(color: context.colorScheme.primary),

              child: Center(
                child: Text(
                  'Setra',
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          CustomDrawerListTile(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              Navigator.of(context).pop();
              context.goNamed(RoutePaths.homeName);
            },
          ),
          CustomDrawerListTile(
            icon: Icons.person,
            title: 'All Collections',
            onTap: () {
              Navigator.of(context).pop();
              context.pushNamed(RoutePaths.productsGenderName);
            },
          ),
          CustomDrawerListTile(
            icon: Icons.person,
            title: 'Mens',
            onTap: () =>
                context.pushNamed(RoutePaths.productsGenderName, extra: 'men'),
          ),
          CustomDrawerListTile(
            icon: Icons.person,
            title: 'Kids',
            onTap: () =>
                context.pushNamed(RoutePaths.productsGenderName, extra: 'kids'),
          ),
          CustomDrawerListTile(
            icon: Icons.local_offer,
            title: 'Summer Collection',
          ),
          CustomDrawerListTile(
            icon: Icons.local_offer_sharp,
            title: 'Winter Collection',
          ),

          CustomDrawerListTile(icon: Icons.local_offer_sharp, title: 'Offers'),
          CustomDrawerListTile(
            icon: Icons.person,
            title: 'Profile',
            onTap: () => _onProfileTap(context),
          ),

          // CustomDrawerListTile(
          //   icon: Icons.logout,
          //   title: 'Logout',
          //   onTap: () => context.read<AuthCubit>().logout(),
          // ),
        ],
      ),
    );
  }
}

class CustomDrawerListTile extends StatelessWidget {
  const CustomDrawerListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.primary),
      title: Text(title, style: context.textTheme.labelLarge),
      onTap: onTap,
    );
  }
}
