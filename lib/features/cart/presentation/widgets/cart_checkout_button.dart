import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';

class CartCheckoutButton extends StatelessWidget {
  const CartCheckoutButton({required this.cart, super.key});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () => context.pushNamed(RoutePaths.checkoutName),
      label: 'Checkout   (${cart.totalPrice.toStringAsFixed(2)})',
    );
  }
}
