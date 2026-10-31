import 'package:flutter/material.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

import 'payment_option.dart';
import 'section_card.dart';

class PaymentMethodSection extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodSection({
    super.key,
    required this.paymentMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Payment Method',
      child: Column(
        children: [
          PaymentOption(
            title: 'Cash on Delivery',
            subtitle: 'Pay when your order arrives',
            icon: Icons.payments_outlined,
            selected: paymentMethod == PaymentMethod.cashOnDelivery,
            onTap: () => onChanged(PaymentMethod.cashOnDelivery),
          ),
          const Divider(height: 1),
          PaymentOption(
            title: 'Online Payment',
            subtitle: 'Pay securely online',
            icon: Icons.credit_card_outlined,
            selected: paymentMethod == PaymentMethod.online,
            onTap: () => onChanged(PaymentMethod.online),
          ),
        ],
      ),
    );
  }
}
