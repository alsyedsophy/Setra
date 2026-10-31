import 'package:flutter/material.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';

import 'section_card.dart';
import 'summary_row.dart';

class OrderSummarySection extends StatelessWidget {
  final CartEntity cart;

  const OrderSummarySection({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Order Summary',
      child: Column(
        children: [
          SummaryRow(title: 'Subtotal', value: cart.totalPrice),
          const SizedBox(height: 8),
          const SummaryRow(title: 'Shipping', value: 0),
          const Divider(height: 24),
          SummaryRow(title: 'Total', value: cart.totalPrice, isTotal: true),
        ],
      ),
    );
  }
}
