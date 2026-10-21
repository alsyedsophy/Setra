import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), centerTitle: true),
      drawer: CustomHomeDrawer(),
      body: BlocBuilder<CartCubit, CartState>(
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
                    return CartItemCard(item: item);
                  },
                ).expanded,
                AppSpacing.h_20.hSpace,
                AppButton(
                  onPressed: () {
                    // context.read<CartCubit>().clearCart();
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
