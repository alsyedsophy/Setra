import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);

  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);

  Future<Either<Failure, List<OrderEntity>>> getUserOrders();

  Stream<Either<Failure, OrderEntity>> watchOrder(String orderId);

  Stream<Either<Failure, List<OrderEntity>>> watchUserOrders();

  Future<Either<Failure, void>> cancelOrder(String orderId);
}
