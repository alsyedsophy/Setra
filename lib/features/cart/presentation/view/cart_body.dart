import 'package:flutter/material.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/cart/presentation/view/cart_responsive_view.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key, required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == CartStatus.error) {
      return AppErrorView(message: state.errorMessage ?? 'An error occurred');
    }

    final isLoading =
        state.status == CartStatus.initial ||
        state.status == CartStatus.loading;

    if (!isLoading &&
        state.status == CartStatus.loaded &&
        state.cartEntity != null &&
        state.cartEntity!.items.isEmpty) {
      return const AppEmptyView(
        message: 'Your cart is empty',
        icon: Icons.shopping_cart_outlined,
      );
    }

    final displayCart = isLoading && state.cartEntity == null
        ? CartEntity.empty()
        : state.cartEntity!;

    final productsById = isLoading
        ? displayCart.items.asMap().map(
            (i, item) => MapEntry(item.productId, ProductEntity.empty()),
          )
        : state.productsById;

    return Skeletonizer(
      enabled: isLoading,
      child: CartResponsiveView(cart: displayCart, productsById: productsById),
    );
  }
}
