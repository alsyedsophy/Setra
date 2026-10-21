import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Stream<CartEntity> call() {
    return repository.getCartItems();
  }
}
