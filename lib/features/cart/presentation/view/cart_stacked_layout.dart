import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/widgets/cart_checkout_button.dart';
import 'package:setra/features/cart/presentation/widgets/cart_items_list.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class CartStackedLayout extends StatelessWidget {
  const CartStackedLayout({
    required this.cart,
    required this.productsById,
    super.key,
  });

  final CartEntity cart;
  final Map<String, ProductEntity?> productsById;

  @override
  Widget build(BuildContext context) {
    // tablet يحتاج عرضاً أقصى ليُمركز؛ mobile يأخذ الشاشة كاملة.
    final maxWidth = context.responsive(mobile: double.infinity, tablet: 720.0);

    final horizontalPadding = context.responsive(
      mobile: AppSpacing.w_16,
      tablet: AppSpacing.w_24,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: CartItemsList(cart: cart, productsById: productsById),
              ),
              AppSpacing.h_20.hSpace,
              CartCheckoutButton(cart: cart).paddingHorizontal(AppSpacing.w_10),
              AppSpacing.h_50.hSpace,
            ],
          ),
        ),
      ),
    );
  }
}
