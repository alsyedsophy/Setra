import 'package:flutter/material.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

import '../price_row.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderEntity order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          PriceRow(title: 'Subtotal', value: order.subtotal),
          const SizedBox(height: 12),
          PriceRow(title: 'Discount', value: -order.discount),
          const SizedBox(height: 12),
          PriceRow(title: 'Shipping', value: order.shippingCost),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          PriceRow(title: 'Total', value: order.total, isTotal: true),
        ],
      ),
    );
  }
}
