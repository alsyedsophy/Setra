import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/products_variant.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this._selectedSize,
    required this.productEntity,
    required this._selectedVariant,
    required this.intialQuantity,
    required this.context,
  });

  final VariantSize? _selectedSize;
  final ProductEntity productEntity;
  final ProductsVariant _selectedVariant;
  final int intialQuantity;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    // final isLoggen =
    //     context.read<AuthCubit>().state.status == AuthStatus.authenticated;
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.unAuthintecated) {
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
                    context.go(RoutePaths.loginName);
                  },
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          );
        } else if (state.status == CartStatus.loaded) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Added Successful')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Error")),
          );
        }
      },
      child: AppButton(
        label: 'Add To Cart',
        onPressed: _selectedSize != null
            ? () {
                final item = CartItemEntity(
                  id: '${productEntity.id}_${_selectedVariant.color}_$_selectedSize',
                  productId: productEntity.id,
                  variantId: _selectedVariant.id,
                  color: _selectedVariant.color,
                  size: _selectedSize.size,
                  imageUrl: productEntity.mainImage,
                  quantity: intialQuantity,
                  price: productEntity.finalPrice,
                );

                // if (!isLoggen) {
                //   context.pushNamed(RoutePaths.loginName);
                // }

                context.read<CartCubit>().addToCart(item);

                log('Add Item');
              }
            : null,
      ),
    );
  }
}
