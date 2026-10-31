import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/checkout/domain/entities/checkout_request_entity.dart';
import 'package:setra/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:setra/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase placeOrderUseCase;

  CheckoutCubit({required this.placeOrderUseCase})
    : super(const CheckoutInitial());

  Future<void> placeOrder(CheckoutRequestEntity request) async {
    if (state is CheckoutLoading) return;

    emit(const CheckoutLoading());

    final result = await placeOrderUseCase(request);

    result.fold(
      (failure) => emit(CheckoutFailure(failure)),
      (order) => emit(CheckoutSuccess(order)),
    );
  }

  void reset() {
    emit(const CheckoutInitial());
  }
}
