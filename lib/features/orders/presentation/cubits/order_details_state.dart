import 'package:equatable/equatable.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {
  const OrderDetailsInitial();
}

class OrderDetailsLoading extends OrderDetailsState {
  const OrderDetailsLoading();
}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderEntity order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailsError extends OrderDetailsState {
  final Failure failure;

  const OrderDetailsError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class OrderDetailsCancelling extends OrderDetailsState {
  final OrderEntity order;

  const OrderDetailsCancelling(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailsCancelled extends OrderDetailsState {
  final OrderEntity order;

  const OrderDetailsCancelled(this.order);

  @override
  List<Object?> get props => [order];
}
