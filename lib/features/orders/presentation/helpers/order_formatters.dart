import 'package:setra/features/orders/domain/entities/order_status.dart';

String formatOrderDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String paymentMethodLabel(PaymentMethod method) => switch (method) {
  PaymentMethod.cashOnDelivery => 'Cash on Delivery',
  PaymentMethod.online => 'Online Payment',
};

String paymentStatusLabel(PaymentStatus status) => switch (status) {
  PaymentStatus.pending => 'Pending',
  PaymentStatus.paid => 'Paid',
  PaymentStatus.failed => 'Failed',
  PaymentStatus.cancelled => 'Cancelled',
  PaymentStatus.refunded => 'Refunded',
};
