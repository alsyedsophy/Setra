import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/widgets/cart_items_list.dart';
import 'package:setra/features/cart/presentation/widgets/cart_order_summary_card.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class CartSplitLayout extends StatelessWidget {
  const CartSplitLayout({
    required this.cart,
    required this.productsById,
    super.key,
  });

  final CartEntity cart;
  final Map<String, ProductEntity?> productsById;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.w_32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CartItemsList(cart: cart, productsById: productsById),
              ),
              AppSpacing.w_24.wSpace,
              Expanded(flex: 1, child: CartOrderSummaryCard(cart: cart)),
            ],
          ),
        ),
      ),
    );
  }
}
