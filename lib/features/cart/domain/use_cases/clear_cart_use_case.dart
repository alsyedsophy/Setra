import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearCart();
  }
}
