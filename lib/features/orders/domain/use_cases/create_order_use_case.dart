import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}
