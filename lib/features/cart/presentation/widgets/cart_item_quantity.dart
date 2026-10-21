import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';

class CartItemQuantity extends StatelessWidget {
  const CartItemQuantity({
    super.key,
    required this.item,
    required this.currentStock,
  });

  final CartItemEntity item;
  final int currentStock;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.w_24,
          height: AppSpacing.h_24,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.r_2.rAll,
            border: Border.all(color: context.colorScheme.primary, width: 0.5),
          ),
          child: GestureDetector(
            onTap: () {
              item.quantity > 1
                  ? context.read<CartCubit>().updateCartItem(
                      item.id,
                      item.quantity - 1,
                    )
                  : null;
            },
            child: Icon(Icons.remove),
          ),
        ),
        Text(item.quantity.toString()),
        Container(
          width: AppSpacing.w_24,
          height: AppSpacing.h_24,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.r_2.rAll,
            border: Border.all(color: context.colorScheme.primary, width: 0.5),
          ),
          child: GestureDetector(
            onTap: () {
              item.quantity < currentStock
                  ? context.read<CartCubit>().updateCartItem(
                      item.id,
                      item.quantity + 1,
                    )
                  : ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'الكمية المتاحة في المخزون هي ($currentStock) فقط',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
