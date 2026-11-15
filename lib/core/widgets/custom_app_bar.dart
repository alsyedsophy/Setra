import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/localization/l10n_extension.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.leading, this.isAuth = false});
  final Widget? leading;
  final bool isAuth;

  @override
  Size get preferredSize => Size.fromHeight(AppSpacing.h_40 + 1);

  @override
  Widget build(BuildContext context) {
    final cartState = isAuth ? null : context.watch<CartCubit>().state;
    final cartCount = cartState?.cartEntity?.items.length;
    log('Cartcount in gneral $cartCount =============');
    return AppBar(
      title: Text(
        context.l10n.tr('appName'),
        style: context.textTheme.titleLarge,
      ),
      leading: leading,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: AppSpacing.h_40,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: context.colorScheme.primary,
          margin: EdgeInsets.zero,
        ),
      ),
      actions: [
        if (!isAuth)
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // final cartState = context.read<CartCubit>().state;
                  // final cout = cartState.cartEntity?.items.length;
                  // log('===================== ${cartState.status} ==============');
                  if (cartState!.status == CartStatus.unAuthintecated) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Login Required'),
                          content: const Text(
                            'You need to sign in to access your profile.',
                          ),
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

                                context.goNamed(RoutePaths.loginName);
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    context.pushNamed(RoutePaths.cartName);
                  }
                },
                icon: Icon(Icons.shopping_cart_outlined),
              ),
              if (cartCount != null && cartCount > 0)
                Positioned(
                  top: AppSpacing.h_4,
                  left: AppSpacing.w_4,
                  child: Text(
                    '$cartCount',
                    style: context.textTheme.titleSmall,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
