import 'package:equatable/equatable.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';

enum CartItemChangeType {
  productRemoved,
  variantUnavailable,
  quantityReduced,
  priceChanged,
}

class CartItemChange extends Equatable {
  final String itemId;
  final String productId;
  final CartItemChangeType type;
  final String message;
  final double? oldPrice;
  final double? newPrice;
  final int? oldQuantity;
  final int? newQuantity;

  const CartItemChange({
    required this.itemId,
    required this.productId,
    required this.type,
    required this.message,
    this.oldPrice,
    this.newPrice,
    this.oldQuantity,
    this.newQuantity,
  });

  @override
  List<Object?> get props => [
    itemId,
    productId,
    type,
    message,
    oldPrice,
    newPrice,
    oldQuantity,
    newQuantity,
  ];
}

class CartValidationResult extends Equatable {
  final CartEntity updatedCart;
  final List<CartItemChange> changes;

  bool get hasChanges => changes.isNotEmpty;

  const CartValidationResult({required this.updatedCart, required this.changes});

  @override
  List<Object?> get props => [updatedCart, changes];
}
