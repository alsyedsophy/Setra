import 'package:get_it/get_it.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/cart/data/data_sources/remote_cart_data_source.dart';
import 'package:setra/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';
import 'package:setra/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/get_cart_items_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/remove_from_cart_use_case.dart';
import 'package:setra/features/cart/domain/use_cases/update_cart_item_use_case.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerCart() async {
  getIt.registerLazySingleton<RemoteCartDataSource>(
    () => RemoteCartDataSourceImpl(firestore: getIt(), auth: getIt()),
  );

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      getIt<RemoteCartDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<GetCartItemsUseCase>(
    () => GetCartItemsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(getIt<CartRepository>()),
  );

  getIt.registerFactory<CartCubit>(
    () => CartCubit(
      addToCartUseCase: getIt<AddToCartUseCase>(),
      updateCartUseCase: getIt<UpdateCartItemUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      getCartUseCase: getIt<GetCartItemsUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
  );
}
