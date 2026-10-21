import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_quantity.dart';

class CartItemCardView extends StatelessWidget {
  const CartItemCardView({
    super.key,
    required this.item,
    required this.currentStock,
  });

  final CartItemEntity item;
  final int currentStock;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: AppSpacing.h_10.pAll,
          margin: AppSpacing.h_10.mV,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: AppSpacing.w_80,
                height: AppSpacing.h_100,
                decoration: BoxDecoration(
                  // color: const Color(0xFFE0E0E0),
                  borderRadius: AppSpacing.r_4.rAll,
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 0.4,
                  ),
                ),
                child: AppNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              AppSpacing.w_10.wSpace,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Setra', style: context.textTheme.bodyLarge),
                  AppSpacing.h_4.hSpace,
                  Text('Teshirt Oversize', style: context.textTheme.bodyMedium),
                  Text(item.variantId, style: context.textTheme.bodyMedium),
                  AppSpacing.h_4.hSpace,
                  Row(
                    children: [
                      Text('Quantity:', style: context.textTheme.bodyMedium),
                      Spacer(),
                      CartItemQuantity(item: item, currentStock: currentStock),
                    ],
                  ),

                  AppSpacing.h_10.hSpace,
                  Row(
                    children: [
                      Text(
                        '${item.price.toStringAsFixed(2)} AGP',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<CartCubit>().removeFromCart(item.id);
                        },
                      ),
                    ],
                  ),
                ],
              ).expanded,
            ],
          ),
        ),
        AppSpacing.h_10.hSpace,
        Divider(
          color: const Color(0xFFE0E0E0),
          thickness: 1,
        ).paddingHorizontal(AppSpacing.w_10),
      ],
    );
  }
}
