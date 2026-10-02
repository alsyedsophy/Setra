import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/products/data/datasources/products_remote_data_source.dart';
import 'package:setra/features/products/data/repositories/products_repo_impl.dart';
import 'package:setra/features/products/domain/products_domain.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';

Future<void> registerProducts() async {
  final GetIt getIt = GetIt.instance;

  // Data sources
  getIt.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      getIt<ProductsRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetRelatedProductsUseCase>(
    () => GetRelatedProductsUseCase(getIt<ProductsRepository>()),
  );

  // Cubits
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getIt<GetProductsUseCase>(),
      getIt<GetRelatedProductsUseCase>(),
    ),
  );
}
