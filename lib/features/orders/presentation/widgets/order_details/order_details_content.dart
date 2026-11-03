import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

import 'cancel_order_button.dart';
import 'order_details_header.dart';
import '../order_item_card.dart';
import 'order_summary_card.dart';
import 'payment_information_card.dart';
import 'section_title.dart';
import 'shipping_address_card.dart';

class OrderDetailsContent extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onCancelOrder;

  const OrderDetailsContent({
    super.key,
    required this.order,
    required this.onCancelOrder,
  });

  @override
  Widget build(BuildContext context) {
    final canCancel =
        order.orderStatus == OrderStatus.pending ||
        order.orderStatus == OrderStatus.confirmed;

    return SingleChildScrollView(
      padding: AppSpacing.w_16.pAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderDetailsHeader(order: order),
          AppSpacing.h_24.hSpace,
          const SectionTitle('Order Items'),
          AppSpacing.h_12.hSpace,
          ...order.items.map((item) => OrderItemCard(item: item)),
          AppSpacing.h_24.hSpace,
          const SectionTitle('Shipping Address'),
          AppSpacing.h_12.hSpace,
          ShippingAddressCard(order: order),
          AppSpacing.h_24.hSpace,
          const SectionTitle('Payment Information'),
          AppSpacing.h_12.hSpace,
          PaymentInformationCard(order: order),
          AppSpacing.h_24.hSpace,
          const SectionTitle('Order Summary'),
          AppSpacing.h_12.hSpace,
          OrderSummaryCard(order: order),
          if (canCancel) ...[
            AppSpacing.h_24.hSpace, // 28
            CancelOrderButton(onCancel: onCancelOrder),
          ],
          AppSpacing.h_24.hSpace,
        ],
      ),
    );
  }
}
