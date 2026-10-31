import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/dependency_injection/dependency_injection.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/orders/data/data_sources/order_remote_data_source.dart';
import 'package:setra/features/orders/data/repositories/oreder_repository_impl.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';
import 'package:setra/features/orders/domain/use_cases/cancel_order_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/create_order_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/get_order_by_id_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/get_user_orders_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/watch_order_use_case.dart';
import 'package:setra/features/orders/domain/use_cases/watch_user_orders_use_case.dart';
import 'package:setra/features/orders/presentation/cubits/order_details_cubit.dart';
import 'package:setra/features/orders/presentation/cubits/orders_cubit.dart';

Future<void> registerOrders() async {
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt<OrderRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<CreateOrderUseCase>(
    () => CreateOrderUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<GetUserOrdersUseCase>(
    () => GetUserOrdersUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<GetOrderByIdUseCase>(
    () => GetOrderByIdUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<CancelOrderUseCase>(
    () => CancelOrderUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<WatchOrderUseCase>(
    () => WatchOrderUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<WatchUserOrdersUseCase>(
    () => WatchUserOrdersUseCase(getIt<OrderRepository>()),
  );

  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(
      watchUserOrdersUseCase: getIt<WatchUserOrdersUseCase>(),
      cancelOrderUseCase: getIt<CancelOrderUseCase>(),
    ),
  );

  getIt.registerFactory<OrderDetailsCubit>(
    () => OrderDetailsCubit(
      watchOrderUseCase: getIt<WatchOrderUseCase>(),
      cancelOrderUseCase: getIt<CancelOrderUseCase>(),
    ),
  );
}
