import 'package:flutter/material.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.confirmed => 'Confirmed',
    OrderStatus.processing => 'Processing',
    OrderStatus.shipped => 'Shipped',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Cancelled',
  };

  Color get color => switch (this) {
    OrderStatus.pending => Colors.orange,
    OrderStatus.confirmed => Colors.blue,
    OrderStatus.processing => Colors.indigo,
    OrderStatus.shipped => Colors.purple,
    OrderStatus.delivered => Colors.green,
    OrderStatus.cancelled => Colors.red,
  };
}
