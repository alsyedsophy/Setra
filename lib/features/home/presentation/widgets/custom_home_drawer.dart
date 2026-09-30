import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({super.key});

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
            onTap: () => context.pop(),
          ),
          CustomDrawerListTile(icon: Icons.person, title: 'Mens'),
          CustomDrawerListTile(icon: Icons.person, title: 'Kids'),
          CustomDrawerListTile(
            icon: Icons.local_offer,
            title: 'Summer Collection',
          ),
          CustomDrawerListTile(
            icon: Icons.local_offer_sharp,
            title: 'Winter Collection',
          ),
          CustomDrawerListTile(icon: Icons.local_offer_sharp, title: 'Offers'),
          CustomDrawerListTile(icon: Icons.person, title: 'Profile'),
          CustomDrawerListTile(icon: Icons.logout, title: 'Logout'),
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
