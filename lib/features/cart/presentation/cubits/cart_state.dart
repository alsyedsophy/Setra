import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/entities/cart_validation_result.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

enum CartStatus { initial, loading, loaded, validating, error, unAuthintecated }

class CartState {
  final CartStatus status;
  final CartEntity? cartEntity;
  final String? errorMessage;

  final List<CartItemChange> validationChanges;
  final Map<String, ProductEntity> productsById;

  const CartState({
    this.status = CartStatus.initial,
    this.errorMessage,
    this.cartEntity,
    this.validationChanges = const [],
    this.productsById = const {},
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cartEntity,
    String? errorMessage,
    bool clearMessage = false,
    List<CartItemChange>? validationChanges,
    bool clearValidationChanges = false,
    Map<String, ProductEntity>? productsById,
  }) {
    return CartState(
      status: status ?? this.status,
      errorMessage: clearMessage ? null : (errorMessage ?? this.errorMessage),
      cartEntity: cartEntity ?? this.cartEntity,
      validationChanges: clearValidationChanges
          ? []
          : (validationChanges ?? this.validationChanges),
      productsById: productsById ?? this.productsById,
    );
  }
}
