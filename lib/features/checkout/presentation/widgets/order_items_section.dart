import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';

import 'section_card.dart';

class OrderItemsSection extends StatelessWidget {
  final CartEntity cart;
  final String Function(String productId) productNameOf;

  const OrderItemsSection({
    super.key,
    required this.cart,
    required this.productNameOf,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Order Items (${cart.totalQuantity})',
      child: Column(
        children: cart.items.map((item) {
          return Row(
            children: [
              ClipRRect(
                borderRadius: AppSpacing.r_8.rAll,
                child: AppNetworkImage(
                  imageUrl: item.imageUrl,
                  width: AppSpacing.w_64,
                  height: AppSpacing.h_72,
                  fit: BoxFit.cover,
                ),
                // child: Image.network(
                //   item.imageUrl,
                //   width: 64,
                //   height: 72,
                //   fit: BoxFit.cover,
                //   errorBuilder: (_, __, ___) => Container(
                //     width: 64,
                //     height: 72,
                //     color: const Color(0xFFF0F0F0),
                //     child: const Icon(Icons.image_not_supported_outlined),
                //   ),
                // ),
              ),
              AppSpacing.w_12.wSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productNameOf(item.productId),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    AppSpacing.h_4.hSpace,
                    Text(
                      '${item.color} / ${item.size}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    AppSpacing.h_4.hSpace,
                    Text('Qty: ${item.quantity}'),
                  ],
                ),
              ),
              AppSpacing.w_8.wSpace,
              Text(
                item.price.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ).paddingVertical(AppSpacing.h_8);
        }).toList(),
      ),
    );
  }
}
