import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/get_cart_items_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/remove_from_cart_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/update_cart_item_use_case.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartItemsUseCase getCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  StreamSubscription? _cartSubscription;

  CartCubit({
    required this.addToCartUseCase,
    required this.updateCartUseCase,
    required this.removeFromCartUseCase,
    required this.getCartUseCase,
    required this.clearCartUseCase,
  }) : super(const CartState()) {
    _init();
  }

  void _init() async {
    emit(state.copyWith(status: CartStatus.loading, clearMessage: true));

    _cartSubscription = getCartUseCase().listen(
      (cartEntity) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: CartStatus.loaded,
              cartEntity: cartEntity,
              clearMessage: true,
            ),
          );
        }
      },
      onError: (failure) {
        log(
          '======================== failure in Cubit $failure ===============',
        );

        if (!isClosed) {
          if (failure is AuthFailure) {
            emit(
              state.copyWith(
                status: CartStatus.unAuthintecated,
                errorMessage: failure.message,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CartStatus.error,
                errorMessage: failure.toString(),
              ),
            );
          }
        }
      },
    );
  }

  Future<void> addToCart(CartItemEntity cartItem) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await addToCartUseCase(cartItem);
    result.fold(
      (failure) {
        if (failure is AuthFailure) {
          emit(
            state.copyWith(
              status: CartStatus.unAuthintecated,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CartStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (_) {
        emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    final result = await updateCartUseCase(itemId, quantity);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  Future<void> removeFromCart(String itemId) async {
    final result = await removeFromCartUseCase(itemId);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  Future<void> clearCart() async {
    final result = await clearCartUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
