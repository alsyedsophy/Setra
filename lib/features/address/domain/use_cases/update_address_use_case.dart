import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call(AddressEntity address) {
    if (address.id.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('معرف العنوان مطلوب')));
    }
    if (address.fullName.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('الاسم مطلوب')));
    }
    if (address.phone.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('رقم الهاتف مطلوب')));
    }
    if (address.city.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('المدينة مطلوبة')));
    }
    if (address.area.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('المنطقة مطلوبة')));
    }
    if (address.street.trim().isEmpty) {
      return Future.value(Left(ValidationFailure('الشارع مطلوب')));
    }
    return repository.updateAddress(address);
  }
}
