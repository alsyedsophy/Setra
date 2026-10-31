import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/cart/domain/entities/cart_validation_result.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showValidationSnackBars(
    BuildContext context,
    List<CartItemChange> changes,
  ) {
    if (changes.isEmpty) return;

    final removed = changes
        .where(
          (c) =>
              c.type == CartItemChangeType.productRemoved ||
              c.type == CartItemChangeType.variantUnavailable,
        )
        .length;
    final qtyReduced = changes
        .where((c) => c.type == CartItemChangeType.quantityReduced)
        .length;
    final priceChanged = changes
        .where((c) => c.type == CartItemChangeType.priceChanged)
        .length;

    final parts = <String>[];
    if (removed > 0) {
      parts.add('تم إزالة $removed منتج غير متاح');
    }
    if (qtyReduced > 0) {
      parts.add('تم تعديل كمية $qtyReduced منتج');
    }
    if (priceChanged > 0) {
      parts.add('تم تحديث سعر $priceChanged منتج');
    }

    if (parts.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(parts.join(' • ')),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.read<CartCubit>().clearValidationChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), centerTitle: true),
      drawer: CustomHomeDrawer(),
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: (prev, curr) =>
            curr.validationChanges.isNotEmpty &&
            prev.validationChanges != curr.validationChanges,
        listener: (context, state) {
          _showValidationSnackBars(context, state.validationChanges);
        },
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const AppLoading();
          } else if (state.status == CartStatus.error) {
            return AppErrorView(
              message: state.errorMessage ?? 'An error occurred',
            );
          } else if (state.status == CartStatus.loaded &&
              state.cartEntity != null) {
            final cartItems = state.cartEntity!.items;
            if (cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            return Column(
              children: [
                ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final product = state.productsById[item.productId];
                    return CartItemCard(item: item, product: product);
                  },
                ).expanded,
                AppSpacing.h_20.hSpace,
                AppButton(
                  onPressed: () {
                    // context.read<CartCubit>().clearCart();
                    context.pushNamed(RoutePaths.checkoutName);
                  },
                  label:
                      'Checkout   (${state.cartEntity!.totalPrice.toStringAsFixed(2)})',
                ).paddingHorizontal(AppSpacing.w_10),
                AppSpacing.h_50.hSpace,
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
