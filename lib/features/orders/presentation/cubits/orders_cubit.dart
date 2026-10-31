import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/use_cases/cancel_order_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/watch_user_orders_use_case.dart';
import 'package:setra/features/orders/presentation/cubits/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final WatchUserOrdersUseCase watchUserOrdersUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  StreamSubscription<dynamic>? _ordersSubscription;

  List<OrderEntity> _orders = [];
  String? _currentUserId;
  String? _cancellingOrderId;

  OrdersCubit({
    required this.watchUserOrdersUseCase,
    required this.cancelOrderUseCase,
  }) : super(const OrdersInitial());

  /// بدء مراقبة طلبات المستخدم الحالي.
  Future<void> watchOrders(String userId) async {
    if (userId.trim().isEmpty) {
      emit(
        OrdersError(ValidationFailure('user_id_required', 'invalid_user_id')),
      );
      return;
    }

    // لا نعيد إنشاء الاشتراك إذا كان المستخدم نفسه تتم مراقبته بالفعل.
    if (_currentUserId == userId && _ordersSubscription != null) {
      return;
    }

    await _ordersSubscription?.cancel();

    _currentUserId = userId;
    _orders = [];
    emit(const OrdersLoading());

    try {
      _ordersSubscription = watchUserOrdersUseCase().listen(
        (result) {
          if (isClosed || _currentUserId != userId) return;

          result.fold((failure) => emit(OrdersError(failure)), (orders) {
            _orders = List<OrderEntity>.unmodifiable(orders);

            if (_orders.isEmpty) {
              emit(const OrdersEmpty());
            } else {
              emit(OrdersLoaded(_orders));
            }
          });
        },
        onError: (Object error, StackTrace stackTrace) {
          if (isClosed || _currentUserId != userId) return;

          emit(
            OrdersError(ServerFailure('watch_orders_failed', 'stream_error')),
          );
        },
      );
    } catch (_) {
      if (!isClosed) {
        emit(OrdersError(ServerFailure('watch_orders_failed', 'stream_error')));
      }
    }
  }

  /// إلغاء طلب.
  Future<void> cancelOrder(String orderId) async {
    if (orderId.trim().isEmpty || _cancellingOrderId != null || isClosed) {
      return;
    }

    final currentOrders = List<OrderEntity>.from(_orders);

    final orderExists = currentOrders.any((order) => order.id == orderId);

    if (!orderExists) return;

    _cancellingOrderId = orderId;

    emit(OrderCancelling(orders: currentOrders, orderId: orderId));

    try {
      final result = await cancelOrderUseCase(orderId);

      if (isClosed) return;

      result.fold(
        (failure) {
          emit(OrdersError(failure));
        },
        (_) {
          emit(OrderCancelled(orders: _orders, orderId: orderId));
        },
      );
    } catch (_) {
      if (!isClosed) {
        emit(OrdersError(ServerFailure('cancel_order_failed', 'cancel_error')));
      }
    } finally {
      _cancellingOrderId = null;
    }
  }

  @override
  Future<void> close() async {
    await _ordersSubscription?.cancel();
    return super.close();
  }
}
