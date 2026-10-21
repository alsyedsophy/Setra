import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  const CustomAppBar({super.key, this.leading});
  final Widget? leading;

  @override
  Size get preferredSize => Size.fromHeight(AppSpacing.h_40 + 1);

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;
    final cartCount = cartState.cartEntity?.items.length;
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
        Stack(
          children: [
            IconButton(
              onPressed: () {
                // final cartState = context.read<CartCubit>().state;
                // final cout = cartState.cartEntity?.items.length;
                // log('===================== ${cartState.status} ==============');
                if (cartState.status == CartStatus.unAuthintecated) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تسجيل الدخول مطلوب'),
                      content: const Text(
                        'يجب تسجيل الدخول لإضافة المنتجات إلى السلة.\nهل تريد الانتقال إلى صفحة تسجيل الدخول؟',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('إلغاء'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.pop();
                            context.pushNamed(RoutePaths.loginName);
                          },
                          child: const Text('تسجيل الدخول'),
                        ),
                      ],
                    ),
                  );
                } else {
                  context.pushNamed(RoutePaths.cartName);
                }
              },
              icon: Icon(Icons.shopping_cart_outlined),
            ),
            if (cartCount != null)
              Positioned(
                top: AppSpacing.h_4,
                left: AppSpacing.w_4,
                child: Text('$cartCount', style: context.textTheme.titleSmall),
              ),
          ],
        ),
      ],
    );
  }
}
