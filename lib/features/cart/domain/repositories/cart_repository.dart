import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem);
  Future<Either<Failure, void>> removeFromCart(String itemId);
  Future<Either<Failure, void>> updateCartItem(String itemId, int quantity);
  Stream<CartEntity> getCartItems();
  Future<Either<Failure, void>> clearCart();

  Future<Either<Failure, void>> replaceCart(CartEntity cart);
}
