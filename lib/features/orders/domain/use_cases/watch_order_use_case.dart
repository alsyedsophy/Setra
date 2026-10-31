import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';

class WatchOrderUseCase {
  final OrderRepository repository;

  WatchOrderUseCase(this.repository);

  Stream<Either<Failure, OrderEntity>> call(String orderId) {
    return repository.watchOrder(orderId);
  }
}
