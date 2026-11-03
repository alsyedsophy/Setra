import 'package:flutter/material.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

import 'detail_info_row.dart';

class ShippingAddressCard extends StatelessWidget {
  final OrderEntity order;

  const ShippingAddressCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final address = order.shippingAddress;
    final hasBuilding =
        address.building != null && address.building!.isNotEmpty;
    final hasNotes = address.notes != null && address.notes!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          DetailInfoRow(title: 'Phone', value: address.phone),
          const SizedBox(height: 8),
          DetailInfoRow(title: 'City', value: address.city),
          const SizedBox(height: 8),
          DetailInfoRow(title: 'Area', value: address.area),
          const SizedBox(height: 8),
          DetailInfoRow(title: 'Street', value: address.street),
          if (hasBuilding) ...[
            const SizedBox(height: 8),
            DetailInfoRow(title: 'Building', value: address.building!),
          ],
          if (hasNotes) ...[
            const SizedBox(height: 12),
            const Text(
              'Additional Notes',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(address.notes!, style: const TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}
