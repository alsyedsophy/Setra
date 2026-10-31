import 'package:equatable/equatable.dart';
import 'package:setra/features/orders/domain/entities/order_shipping_address_entity.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String variantId;

  final String productName;
  final String imageUrl;
  final String color;
  final String size;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItemEntity({
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.imageUrl,
    required this.color,
    required this.size,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
    productId,
    variantId,
    productName,
    imageUrl,
    color,
    size,
    quantity,
    unitPrice,
    totalPrice,
  ];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;

  final List<OrderItemEntity> items;

  final OrderShippingAddressEntity shippingAddress;

  final double subtotal;
  final double discount;
  final double shippingCost;
  final double total;

  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.total,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    shippingAddress,
    subtotal,
    discount,
    shippingCost,
    total,
    orderStatus,
    paymentStatus,
    paymentMethod,
    createdAt,
    updatedAt,
  ];
}
