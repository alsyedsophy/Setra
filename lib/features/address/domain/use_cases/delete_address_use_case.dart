import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> call(String addressId) {
    if (addressId.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('معرف العنوان مطلوب')));
    }
    return repository.deleteAddress(addressId);
  }
}
