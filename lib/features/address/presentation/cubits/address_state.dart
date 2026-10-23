import 'package:setra/features/address/domain/entities/address_entity.dart';

enum AddressStatus {
  initial,
  loading,
  loaded,
  saving,
  success,
  error,
  unAuthenticated,
}

class AddressState {
  final AddressStatus status;
  final List<AddressEntity> addresses;
  final AddressEntity? defaultAddress;
  final AddressEntity? selectedAddress; // للاستخدام في Checkout لاحقًا
  final String? errorMessage;
  final String? successMessage;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.defaultAddress,
    this.selectedAddress,
    this.errorMessage,
    this.successMessage,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<AddressEntity>? addresses,
    AddressEntity? defaultAddress,
    AddressEntity? selectedAddress,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSelected = false,
    bool clearDefault = false,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      defaultAddress: clearDefault
          ? null
          : (defaultAddress ?? this.defaultAddress),
      selectedAddress: clearSelected
          ? null
          : (selectedAddress ?? this.selectedAddress),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
