import 'package:setra/core/dependency_injection/dependency_injection.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';
import 'package:setra/features/cart/domain/use_cases/validate_and_sync_cart_use_case.dart';
import 'package:setra/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:setra/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';

Future<void> registerCheckout() async {
  getIt.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(
      cartRepository: getIt<CartRepository>(),
      addressRepository: getIt<AddressRepository>(),
      orderRepository: getIt<OrderRepository>(),
      validateAndSyncCart: getIt<ValidateAndSyncCartUseCase>(),
    ),
  );

  getIt.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(placeOrderUseCase: getIt<PlaceOrderUseCase>()),
  );
}
