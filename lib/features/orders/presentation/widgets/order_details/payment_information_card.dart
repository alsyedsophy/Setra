import 'package:flutter/material.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

import '../../helpers/order_formatters.dart';
import 'detail_info_row.dart';

class PaymentInformationCard extends StatelessWidget {
  final OrderEntity order;

  const PaymentInformationCard({super.key, required this.order});

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
          DetailInfoRow(
            title: 'Payment Method',
            value: paymentMethodLabel(order.paymentMethod),
          ),
          const SizedBox(height: 12),
          DetailInfoRow(
            title: 'Payment Status',
            value: paymentStatusLabel(order.paymentStatus),
          ),
        ],
      ),
    );
  }
}
