import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/entities/cart_validation_result.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          
          if (state.status == CartStatus.error) {
            return AppErrorView(
              message: state.errorMessage ?? 'An error occurred',
            );
          }
          final isLoading = state.status == CartStatus.initial ||
              state.status == CartStatus.loading;

          if (!isLoading && state.status == CartStatus.loaded &&
              state.cartEntity != null && state.cartEntity!.items.isEmpty) {
              return AppEmptyView(
                message: 'Your cart is empty',
                icon: Icons.shopping_cart_outlined,
              );
            
          }

          final displayCart = isLoading && state.cartEntity == null
              ? CartEntity.empty()
              : state.cartEntity!;
          
          final productsById = isLoading
              ? displayCart.items.asMap().map((index, item) => MapEntry(item.productId, ProductEntity.empty()))
              : state.productsById;

          return Skeletonizer(
            enabled: isLoading,
            child: Column(
                children: [
                  ListView.builder(
                    itemCount: displayCart.items.length,
                    itemBuilder: (context, index) {
                      final item = displayCart.items[index];
                      final product = productsById[item.productId];
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
              ),
          );
        },
      ),
    );
  }
}
