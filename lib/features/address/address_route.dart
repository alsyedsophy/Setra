import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/presentation/cubits/address_cubit.dart';
import 'package:setra/features/address/presentation/screens/address_form_screen.dart';
import 'package:setra/features/address/presentation/screens/addresses_screen.dart';

List<RouteBase> get addressRoutes => [
  GoRoute(
    path: RoutePaths.addresses,
    name: RoutePaths.addressesName,
    builder: (context, state) => BlocProvider.value(
      value: context.read<AddressCubit>(),
      child: const AddressesScreen(),
    ),
  ),
  GoRoute(
    path: RoutePaths.addressForm,
    name: RoutePaths.addressFormName,
    builder: (context, state) {
      final address = state.extra as AddressEntity?;
      return BlocProvider.value(
        value: context.read<AddressCubit>(),
        child: AddressFormScreen(address: address),
      );
    },
  ),
];
