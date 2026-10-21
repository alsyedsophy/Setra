import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String id;
  final double totalPrice;
  final int totalQuantity;
  final List<CartItemEntity> items;

  const CartEntity({
    required this.id,
    required this.totalPrice,
    required this.totalQuantity,
    required this.items,
  });

  CartEntity copyWith({
    String? id,
    double? totalPrice,
    int? totalQuantity,
    List<CartItemEntity>? items,
  }) {
    return CartEntity(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, totalPrice, totalQuantity, items];
}

class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String variantId;
  final String color;
  final String size;
  final String imageUrl;
  final int quantity;
  final double price;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.color,
    required this.size,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  CartItemEntity copyWith({
    String? id,
    String? productId,
    String? variantId,
    String? color,
    String? size,
    String? imageUrl,
    int? quantity,
    double? price,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      color: color ?? this.color,
      size: size ?? this.size,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    variantId,
    color,
    size,
    imageUrl,
    quantity,
    price,
  ];
}
