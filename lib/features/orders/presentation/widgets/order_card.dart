import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';
import 'package:setra/features/orders/presentation/cubits/orders_cubit.dart';

import '../helpers/order_formatters.dart';
import 'cancel_order_dialog.dart';
import 'order_info_row.dart';
import 'order_details/order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final bool isCancelling;

  const OrderCard({super.key, required this.order, required this.isCancelling});

  bool get _canCancel =>
      order.orderStatus == OrderStatus.pending ||
      order.orderStatus == OrderStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: AppSpacing.r_12.rAll,
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderHeader(order: order),
          const Divider(height: 1),
          _OrderInfoSection(order: order),
          const Divider(height: 1),
          _OrderFooter(
            order: order,
            isCancelling: isCancelling,
            canCancel: _canCancel,
            onCancel: () => _handleCancel(context),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCancel(BuildContext context) async {
    final confirmed = await showCancelOrderDialog(context);
    if (confirmed && context.mounted) {
      context.read<OrdersCubit>().cancelOrder(order.id);
    }
  }
}

// ============================================================
// Header
// ============================================================

class _OrderHeader extends StatelessWidget {
  final OrderEntity order;

  const _OrderHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Number',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '#${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          OrderStatusBadge(status: order.orderStatus),
        ],
      ),
    );
  }
}

// ============================================================
// Info Section
// ============================================================

class _OrderInfoSection extends StatelessWidget {
  final OrderEntity order;

  const _OrderInfoSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          OrderInfoRow(
            title: 'Order Date',
            value: formatOrderDate(order.createdAt),
          ),
          const SizedBox(height: 10),
          OrderInfoRow(title: 'Items', value: '${order.items.length} products'),
          const SizedBox(height: 10),
          OrderInfoRow(
            title: 'Payment',
            value: paymentMethodLabel(order.paymentMethod),
          ),
          const SizedBox(height: 10),
          OrderInfoRow(
            title: 'Payment Status',
            value: paymentStatusLabel(order.paymentStatus),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Footer
// ============================================================

class _OrderFooter extends StatelessWidget {
  final OrderEntity order;
  final bool isCancelling;
  final bool canCancel;
  final VoidCallback onCancel;

  const _OrderFooter({
    required this.order,
    required this.isCancelling,
    required this.canCancel,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Amount',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                order.total.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (canCancel)
                Expanded(
                  child: OutlinedButton(
                    onPressed: isCancelling ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: isCancelling
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Cancel Order'),
                  ),
                ),
              if (canCancel) const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(
                      RoutePaths.orderDetailsName,
                      extra: order.id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
