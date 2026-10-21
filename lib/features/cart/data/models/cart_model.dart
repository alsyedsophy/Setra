import 'package:setra/features/cart/domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.totalPrice,
    required super.totalQuantity,
    required super.items,
  });

  factory CartModel.fromFireStore(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      totalPrice: json['total_price'] as double,
      totalQuantity: json['total_quantity'] as int,
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => CartItemModel.fromFireStore(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'total_price': totalPrice,
      'total_quantity': totalQuantity,
      'items': items
          .map((item) => (item as CartItemModel).toFireStore())
          .toList(),
    };
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      totalPrice: entity.totalPrice,
      totalQuantity: entity.totalQuantity,
      items: entity.items
          .map((item) => CartItemModel.fromEntity(item))
          .toList(),
    );
  }
}

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.variantId,
    required super.color,
    required super.size,
    required super.imageUrl,
    required super.quantity,
    required super.price,
  });

  factory CartItemModel.fromFireStore(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String,
      color: json['color'] as String,
      size: json['size'] as String,
      imageUrl: json['image_url'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as double,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'product_id': productId,
      'variant_id': variantId,
      'color': color,
      'size': size,
      'image_url': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      productId: entity.productId,
      variantId: entity.variantId,
      color: entity.color,
      size: entity.size,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      price: entity.price,
    );
  }
}
