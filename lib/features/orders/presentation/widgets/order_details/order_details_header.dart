import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

import '../../helpers/order_formatters.dart';
import 'detail_info_row.dart';
import 'order_status_badge.dart';

class OrderDetailsHeader extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsHeader({super.key, required this.order});

  int get _totalItems =>
      order.items.fold<int>(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.w_18.pAll,
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: AppSpacing.r_15.rAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Number',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          AppSpacing.h_6.hSpace,
          SelectableText(order.id, style: context.textTheme.labelLarge),
          AppSpacing.h_16.hSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              OrderStatusBadge(status: order.orderStatus),
            ],
          ),
          AppSpacing.h_12.hSpace,
          DetailInfoRow(
            title: 'Order Date',
            value: formatOrderDate(order.createdAt),
          ),
          AppSpacing.h_8.hSpace,
          DetailInfoRow(title: 'Total Items', value: _totalItems.toString()),
        ],
      ),
    );
  }
}
