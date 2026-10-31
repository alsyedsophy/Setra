import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';

class WatchUserOrdersUseCase {
  final OrderRepository repository;

  WatchUserOrdersUseCase(this.repository);

  Stream<Either<Failure, List<OrderEntity>>> call() {
    return repository.watchUserOrders();
  }
}
