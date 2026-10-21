import 'package:setra/features/cart/domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, loaded, error, unAuthintecated }

class CartState {
  final CartStatus status;
  final CartEntity? cartEntity;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.errorMessage,
    this.cartEntity,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cartEntity,
    String? errorMessage,
    bool clearMessage = false,
  }) {
    return CartState(
      status: status ?? this.status,
      errorMessage: clearMessage ? null : (errorMessage ?? this.errorMessage),
      cartEntity: cartEntity ?? this.cartEntity,
    );
  }
}
