import 'package:get_it/get_it.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/address/data/data_sources/remote_address_data_source.dart';
import 'package:setra/features/address/data/repositories/address_repository_impl.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';
import 'package:setra/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:setra/features/address/domain/use_cases/get_default_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/set_default_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:setra/features/address/presentation/cubits/address_cubit.dart';

Future<void> registerAddress() async {
  final getIt = GetIt.instance;

  // Data source
  getIt.registerLazySingleton<RemoteAddressDataSource>(
    () => RemoteAddressDataSourceImpl(
      firestore: getIt(),
      auth: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: getIt<RemoteAddressDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetAddressesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetDefaultAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => AddAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => SetDefaultAddressUseCase(getIt()));

  // Cubit
  getIt.registerFactory(
    () => AddressCubit(
      getAddressesUseCase: getIt(),
      getDefaultAddressUseCase: getIt(),
      addAddressUseCase: getIt(),
      updateAddressUseCase: getIt(),
      deleteAddressUseCase: getIt(),
      setDefaultAddressUseCase: getIt(),
    ),
  );
}
