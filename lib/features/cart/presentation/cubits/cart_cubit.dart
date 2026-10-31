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
import 'package:setra/features/cart/domain/use_cases/validate_and_sync_cart_use_case.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/products_domain.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartItemsUseCase getCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final ValidateAndSyncCartUseCase validateAndSyncCartUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;

  StreamSubscription? _cartSubscription;

  /// عشان مفيش validation تتكرر على نفس الـ snapshot بعد ما احنا كتبنا التحديث
  bool _isValidating = false;
  bool _skipNextValidation = false;
  bool _skipNextStreamApply = false;

  CartCubit({
    required this.addToCartUseCase,
    required this.updateCartUseCase,
    required this.removeFromCartUseCase,
    required this.getCartUseCase,
    required this.clearCartUseCase,
    required this.validateAndSyncCartUseCase,
    required this.getProductByIdUseCase,
  }) : super(const CartState()) {
    _init();
  }

  void _init() async {
    emit(state.copyWith(status: CartStatus.loading, clearMessage: true));

    _cartSubscription = getCartUseCase().listen(
      (cartEntity) async {
        if (isClosed) return;
        // نتخطى ال optemistec update
        if (_skipNextStreamApply) {
          _skipNextStreamApply = false;
          _skipNextValidation = false;
          return; // متعملش rebuild ولا validation
        }
        // نتخطى ال validation فى حالة الكتابة فقط
        if (_skipNextValidation) {
          _skipNextValidation = false;
          emit(
            state.copyWith(
              status: CartStatus.loaded,
              cartEntity: cartEntity,
              clearMessage: true,
            ),
          );

          await _prefetchProducts(cartEntity);
          return;
        }
        // [3] كارت فاضي: لا شيء للتحقق منه
        if (cartEntity.items.isEmpty) {
          emit(
            state.copyWith(
              status: CartStatus.loaded,
              cartEntity: cartEntity,
              clearMessage: true,
            ),
          );
          return;
        }

        // [4] validation شغالة بالفعل: نطبّق الـ snapshot فقط
        if (_isValidating) {
          emit(
            state.copyWith(
              status: CartStatus.loaded,
              cartEntity: cartEntity,
              clearMessage: true,
            ),
          );
          await _prefetchProducts(cartEntity);
          return;
        }

        // [5] المسار العادي: validation هي التي ستُصدر الـ status
        await _validateAndSync(cartEntity);
      },
      onError: (failure) {
        log(
          '======================== failure in Cubit $failure ===============',
        );

        if (isClosed) return;
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
      },
    );
  }

  Future<void> addToCart(CartItemEntity cartItem) async {
    emit(state.copyWith(status: CartStatus.loading));
    _skipNextValidation = true;
    final result = await addToCartUseCase(cartItem);
    result.fold(
      (failure) {
        _skipNextValidation = false;
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
        // emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    final currentCart = state.cartEntity;
    if (currentCart == null) return;

    final updatedItems = currentCart.items.map((item) {
      if (item.id != itemId) return item;
      final unitPrice = item.quantity > 0
          ? item.price / item.quantity
          : item.price;
      return item.copyWith(quantity: quantity, price: unitPrice * quantity);
    }).toList();

    final newTotalPrice = updatedItems.fold<double>(0.0, (s, i) => s + i.price);
    final newTotalQuantity = updatedItems.fold<int>(
      0,
      (s, i) => s + i.quantity,
    );

    emit(
      state.copyWith(
        cartEntity: currentCart.copyWith(
          items: updatedItems,
          totalPrice: newTotalPrice,
          totalQuantity: newTotalQuantity,
        ),
        status: CartStatus.loaded,
        clearMessage: true,
      ),
    );

    // 2) تجاهل الـ snapshot الجاي من Firestore
    _skipNextStreamApply = true;
    _skipNextValidation = true;

    // 3) اكتب على السيرفر
    final result = await updateCartUseCase(itemId, quantity);
    result.fold((failure) {
      // فشل → رجّع النسخة القديمة
      _skipNextStreamApply = false;
      _skipNextValidation = false;
      emit(
        state.copyWith(
          cartEntity: currentCart,
          status: CartStatus.loaded,
          errorMessage: failure.message,
        ),
      );
    }, (_) {});
  }

  Future<void> removeFromCart(String itemId) async {
    _skipNextValidation = true;
    final result = await removeFromCartUseCase(itemId);
    result.fold(
      (failure) {
        _skipNextValidation = false;
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        // emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  Future<void> clearCart() async {
    _skipNextValidation = true;
    final result = await clearCartUseCase();
    result.fold(
      (failure) {
        _skipNextValidation = false;
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        // emit(state.copyWith(status: CartStatus.loaded, clearMessage: true));
      },
    );
  }

  /// التحقق والمزامنة التلقائية
  Future<void> _validateAndSync(CartEntity cart) async {
    if (_isValidating || cart.items.isEmpty) return;
    _isValidating = true;

    emit(state.copyWith(status: CartStatus.validating));

    final result = await validateAndSyncCartUseCase(cart);
    if (isClosed) return;
    result.fold(
      (failure) {
        log('Validation failed: ${failure.message}');
        // فشل التحقق مش معناه نفشل الكارت كله — نعرض الكارت كما هو
        emit(
          state.copyWith(
            status: CartStatus.loaded,
            errorMessage: failure.message,
          ),
        );
      },
      (validationResult) async {
        if (validationResult.hasChanges) {
          // الـ stream هيرجع بعد الـ replaceCart → نتخطى validation الجاية
          _skipNextValidation = true;
        }

        emit(
          state.copyWith(
            status: CartStatus.loaded,
            cartEntity: validationResult.updatedCart,
            validationChanges: validationResult.changes,
            clearMessage: true,
          ),
        );
      },
    );
    final updatedCart = state.cartEntity;
    if (!isClosed && updatedCart != null) {
      await _prefetchProducts(updatedCart);
    }

    _isValidating = false;
  }

  /// يجيب المنتجات مرة واحدة ويخزنها في الـ state عشان الـ cards
  Future<void> _prefetchProducts(CartEntity cart) async {
    if (cart.items.isEmpty) return;

    final Map<String, ProductEntity> map = Map.from(state.productsById);
    final uniqueIds = cart.items.map((e) => e.productId).toSet();

    for (final id in uniqueIds) {
      if (map.containsKey(id)) continue;
      final result = await getProductByIdUseCase(id);
      result.fold((_) {}, (product) => map[id] = product);
    }

    if (!isClosed) {
      emit(state.copyWith(productsById: map));
    }
  }

  /// يستدعيها الـ UI بعد ما يعرض الـ SnackBars
  void clearValidationChanges() {
    emit(state.copyWith(clearValidationChanges: true));
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
