import 'package:equatable/equatable.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersEmpty extends OrdersState {
  const OrdersEmpty();
}

class OrdersError extends OrdersState {
  final Failure failure;

  const OrdersError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class OrderCancelling extends OrdersState {
  final List<OrderEntity> orders;
  final String orderId;

  const OrderCancelling({required this.orders, required this.orderId});

  @override
  List<Object?> get props => [orders, orderId];
}

class OrderCancelled extends OrdersState {
  final List<OrderEntity> orders;
  final String orderId;

  const OrderCancelled({required this.orders, required this.orderId});

  @override
  List<Object?> get props => [orders, orderId];
}
