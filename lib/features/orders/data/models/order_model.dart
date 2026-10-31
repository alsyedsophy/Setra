import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/features/orders/data/models/order_shipping_address_model.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.variantId,
    required super.productName,
    required super.imageUrl,
    required super.color,
    required super.size,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
  });

  factory OrderItemModel.fromFirestore(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      variantId: map['variantId'] ?? '',
      productName: map['productName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      quantity: (map['quantity'] ?? 0) as int,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'variantId': variantId,
      'productName': productName,
      'imageUrl': imageUrl,
      'color': color,
      'size': size,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      productId: entity.productId,
      variantId: entity.variantId,
      productName: entity.productName,
      imageUrl: entity.imageUrl,
      color: entity.color,
      size: entity.size,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.shippingAddress,
    required super.subtotal,
    required super.discount,
    required super.shippingCost,
    required super.total,
    required super.orderStatus,
    required super.paymentStatus,
    required super.paymentMethod,
    required super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      items:
          (data['items'])
              ?.map(
                (item) =>
                    OrderItemModel.fromFirestore(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      shippingAddress: OrderShippingAddressModel.fromFirestore(
        data['shippingAddress'] as Map<String, dynamic>? ?? {},
      ),
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      discount: (data['discount'] ?? 0.0).toDouble(),
      shippingCost: (data['shippingCost'] ?? 0.0).toDouble(),
      total: (data['total'] ?? 0.0).toDouble(),
      orderStatus: OrderStatus.values.byName(data['orderStatus'] ?? 'pending'),
      paymentStatus: PaymentStatus.values.byName(
        data['paymentStatus'] ?? 'pending',
      ),
      paymentMethod: PaymentMethod.values.byName(
        data['paymentMethod'] ?? 'cashOnDelivery',
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items
          .map((item) => (item as OrderItemModel).toFirestore())
          .toList(),
      'shippingAddress': (shippingAddress as OrderShippingAddressModel)
          .toFirestore(),
      'subtotal': subtotal,
      'discount': discount,
      'shippingCost': shippingCost,
      'total': total,
      'orderStatus': orderStatus.name,
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items
          .map((item) => OrderItemModel.fromEntity(item))
          .toList(),
      shippingAddress: entity.shippingAddress,
      subtotal: entity.subtotal,
      discount: entity.discount,
      shippingCost: entity.shippingCost,
      total: entity.total,
      orderStatus: entity.orderStatus,
      paymentStatus: entity.paymentStatus,
      paymentMethod: entity.paymentMethod,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
