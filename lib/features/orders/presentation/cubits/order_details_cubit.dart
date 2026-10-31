import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/orders/domain/use_cases/cancel_order_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/watch_order_use_case.dart';
import 'package:setra/features/orders/presentation/cubits/order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final WatchOrderUseCase watchOrderUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  StreamSubscription<dynamic>? _orderSubscription;

  String? _currentOrderId;
  bool _isCancelling = false;

  OrderDetailsCubit({
    required this.watchOrderUseCase,
    required this.cancelOrderUseCase,
  }) : super(const OrderDetailsInitial());

  /// مراقبة تفاصيل طلب محدد.
  Future<void> watchOrder(String orderId) async {
    if (orderId.trim().isEmpty) {
      emit(
        OrderDetailsError(
          ValidationFailure('order_id_required', 'invalid_order_id'),
        ),
      );
      return;
    }

    if (_currentOrderId == orderId && _orderSubscription != null) {
      return;
    }

    await _orderSubscription?.cancel();

    _currentOrderId = orderId;
    emit(const OrderDetailsLoading());

    try {
      _orderSubscription = watchOrderUseCase(orderId).listen(
        (result) {
          if (isClosed || _currentOrderId != orderId) return;

          result.fold(
            (failure) => emit(OrderDetailsError(failure)),
            (order) => emit(OrderDetailsLoaded(order)),
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          if (isClosed || _currentOrderId != orderId) return;

          emit(
            OrderDetailsError(
              ServerFailure('watch_order_failed', 'stream_error'),
            ),
          );
        },
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          OrderDetailsError(
            ServerFailure('watch_order_failed', 'stream_error'),
          ),
        );
      }
    }
  }

  /// إلغاء الطلب الحالي.
  Future<void> cancelOrder() async {
    if (_isCancelling || isClosed) return;

    final currentState = state;

    if (currentState is! OrderDetailsLoaded) return;

    final order = currentState.order;

    _isCancelling = true;
    emit(OrderDetailsCancelling(order));

    try {
      final result = await cancelOrderUseCase(order.id);

      if (isClosed) return;

      result.fold(
        (failure) => emit(OrderDetailsError(failure)),
        (_) => emit(OrderDetailsCancelled(order)),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          OrderDetailsError(
            ServerFailure('cancel_order_failed', 'cancel_error'),
          ),
        );
      }
    } finally {
      _isCancelling = false;
    }
  }

  @override
  Future<void> close() async {
    await _orderSubscription?.cancel();
    return super.close();
  }
}
