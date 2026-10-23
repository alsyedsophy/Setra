import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/address/presentation/cubits/address_cubit.dart';
import 'package:setra/features/address/presentation/cubits/address_state.dart';
import 'package:setra/features/address/presentation/widgets/address_card.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Address'), centerTitle: true),
      drawer: CustomHomeDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(RoutePaths.addressFormName);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Address'),
      ),
      body: BlocConsumer<AddressCubit, AddressState>(
        listenWhen: (prev, curr) =>
            (curr.successMessage != null &&
                curr.successMessage != prev.successMessage) ||
            (curr.errorMessage != null &&
                curr.errorMessage != prev.errorMessage),
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.successMessage!)));
            context.read<AddressCubit>().clearMessages();
          } else if (state.errorMessage != null &&
              state.status == AddressStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<AddressCubit>().clearMessages();
          }
        },
        builder: (context, state) {
          if (state.status == AddressStatus.loading &&
              state.addresses.isEmpty) {
            return const AppLoading();
          }

          // if (state.status == AddressStatus.unAuthenticated) {
          //   return const Center(
          //     child: Text('يجب تسجيل الدخول لعرض العناوين'),
          //   );
          // }

          if (state.status == AddressStatus.error && state.addresses.isEmpty) {
            return AppErrorView(
              message: state.errorMessage ?? 'حدث خطأ',
              onRetry: () => context.read<AddressCubit>().loadAddresses(),
            );
          }

          if (state.addresses.isEmpty) {
            return AppEmptyView(message: 'No Address yet');
          }

          return RefreshIndicator(
            onRefresh: () => context.read<AddressCubit>().loadAddresses(),
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.w_16,
                AppSpacing.h_16,
                AppSpacing.w_16,
                AppSpacing.h_88,
              ),
              itemCount: state.addresses.length,
              separatorBuilder: (_, _) => AppSpacing.h_16.hSpace,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return AddressCard(
                  address: address,
                  selected: state.selectedAddress?.id == address.id,
                  onTap: () {
                    context.read<AddressCubit>().selectAddress(address);
                  },
                  onEdit: () {
                    context.pushNamed(
                      RoutePaths.addressFormName,
                      extra: address,
                    );
                  },
                  onDelete: () => _confirmDelete(context, address.id),
                  onSetDefault: () {
                    context.read<AddressCubit>().setDefault(address.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String addressId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف العنوان'),
        content: const Text('هل أنت متأكد من حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<AddressCubit>().deleteAddress(addressId);
    }
  }
}
