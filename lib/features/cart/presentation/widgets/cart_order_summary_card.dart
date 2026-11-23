import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/widgets/cart_checkout_button.dart';

class CartOrderSummaryCard extends StatelessWidget {
  const CartOrderSummaryCard({required this.cart, super.key});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.w_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order Summary', style: theme.textTheme.titleLarge),
            AppSpacing.h_16.hSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.bodyLarge),
                Text(
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            AppSpacing.h_16.hSpace,
            CartCheckoutButton(cart: cart),
          ],
        ),
      ),
    );
  }
}
