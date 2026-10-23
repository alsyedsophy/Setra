import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:setra/features/address/domain/use_cases/get_default_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/set_default_address_use_case.dart';
import 'package:setra/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:setra/features/address/presentation/cubits/address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetDefaultAddressUseCase getDefaultAddressUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  AddressCubit({
    required this.getAddressesUseCase,
    required this.getDefaultAddressUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  }) : super(const AddressState());

  Future<void> loadAddresses() async {
    emit(state.copyWith(status: AddressStatus.loading, clearError: true));

    final result = await getAddressesUseCase();
    result.fold((failure) => _emitFailure(failure), (addresses) {
      AddressEntity? defaultAddress;
      for (final a in addresses) {
        if (a.isDefault) {
          defaultAddress = a;
          break;
        }
      }
      defaultAddress ??= addresses.isNotEmpty ? addresses.first : null;

      emit(
        state.copyWith(
          status: AddressStatus.loaded,
          addresses: addresses,
          defaultAddress: defaultAddress,
          selectedAddress: state.selectedAddress ?? defaultAddress,
          clearError: true,
        ),
      );
    });
  }

  Future<void> loadDefaultAddress() async {
    final result = await getDefaultAddressUseCase();
    result.fold((failure) => _emitFailure(failure), (address) {
      emit(
        state.copyWith(
          status: AddressStatus.loaded,
          defaultAddress: address,
          selectedAddress: state.selectedAddress ?? address,
          clearError: true,
        ),
      );
    });
  }

  void selectAddress(AddressEntity address) {
    emit(state.copyWith(selectedAddress: address));
  }

  Future<void> addAddress({
    required String fullName,
    required String phone,
    required String city,
    required String area,
    required String street,
    String? building,
    String? notes,
    bool isDefault = false,
  }) async {
    emit(state.copyWith(status: AddressStatus.saving, clearError: true));

    final entity = AddressEntity(
      id: '',
      userId: '',
      fullName: fullName,
      phone: phone,
      city: city,
      area: area,
      street: street,
      building: building,
      notes: notes,
      isDefault: isDefault,
      createdAt: DateTime.now(),
    );

    final result = await addAddressUseCase(entity);
    result.fold((failure) => _emitFailure(failure), (added) async {
      await loadAddresses();
      // emit(
      //   state.copyWith(
      //     status: AddressStatus.success,
      //     successMessage: 'تم إضافة العنوان بنجاح',
      //     clearError: true,
      //   ),
      // );
    });
  }

  Future<void> updateAddress(AddressEntity address) async {
    emit(state.copyWith(status: AddressStatus.saving, clearError: true));

    final result = await updateAddressUseCase(address);
    result.fold((failure) => _emitFailure(failure), (_) async {
      await loadAddresses();
      // emit(
      //   state.copyWith(
      //     status: AddressStatus.success,
      //     successMessage: 'تم تحديث العنوان بنجاح',
      //     clearError: true,
      //   ),
      // );
    });
  }

  Future<void> deleteAddress(String addressId) async {
    emit(state.copyWith(status: AddressStatus.loading, clearError: true));

    final result = await deleteAddressUseCase(addressId);
    result.fold((failure) => _emitFailure(failure), (_) async {
      await loadAddresses();
      emit(
        state.copyWith(
          status: AddressStatus.success,
          successMessage: 'تم حذف العنوان',
          clearError: true,
        ),
      );
    });
  }

  Future<void> setDefault(String addressId) async {
    final result = await setDefaultAddressUseCase(addressId);
    result.fold((failure) => _emitFailure(failure), (_) async {
      await loadAddresses();
      emit(
        state.copyWith(
          status: AddressStatus.success,
          successMessage: 'تم تعيين العنوان الافتراضي',
          clearError: true,
        ),
      );
    });
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  void _emitFailure(Failure failure) {
    if (failure is AuthFailure) {
      emit(
        state.copyWith(
          status: AddressStatus.unAuthenticated,
          errorMessage: failure.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AddressStatus.error,
          errorMessage: failure.message,
        ),
      );
    }
  }
}
