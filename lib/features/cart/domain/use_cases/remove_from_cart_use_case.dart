import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await repository.removeFromCart(productId);
  }
}
