enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentStatus { pending, paid, failed, cancelled, refunded }

enum PaymentMethod { cashOnDelivery, online }
