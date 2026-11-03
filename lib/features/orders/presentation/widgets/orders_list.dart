import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

import 'order_card.dart';

class OrdersList extends StatelessWidget {
  final List<OrderEntity> orders;
  final String? cancellingOrderId;

  const OrdersList({super.key, required this.orders, this.cancellingOrderId});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        // الطلبات تعتمد على Stream، لذلك إعادة الاشتراك ليست ضرورية
        // طالما أن الـ Stream يعمل بالفعل.
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      child: Column(
        children: [
          ListView.separated(
            padding: AppSpacing.w_16.pAll,
            itemCount: orders.length,
            separatorBuilder: (_, _) => AppSpacing.h_12.hSpace,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                isCancelling: cancellingOrderId == order.id,
              );
            },
          ).expanded,
          AppSpacing.h_50.hSpace,
        ],
      ),
    );
  }
}
