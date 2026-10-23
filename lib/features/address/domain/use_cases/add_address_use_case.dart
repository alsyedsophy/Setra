import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;

  AddAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call(AddressEntity address) {
    final error = _validate(address);
    if (error != null) {
      return Future.value(Left(ValidationFailure(error)));
    }
    return repository.addAddress(address);
  }

  String? _validate(AddressEntity a) {
    if (a.fullName.trim().isEmpty) return 'الاسم مطلوب';
    if (a.phone.trim().isEmpty) return 'رقم الهاتف مطلوب';
    if (!_isValidEgyptianPhone(a.phone.trim())) {
      return 'رقم الهاتف غير صحيح';
    }
    if (a.city.trim().isEmpty) return 'المدينة مطلوبة';
    if (a.area.trim().isEmpty) return 'المنطقة مطلوبة';
    if (a.street.trim().isEmpty) return 'الشارع مطلوب';
    return null;
  }

  bool _isValidEgyptianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '');
    // 01xxxxxxxxx أو +201xxxxxxxxx أو 201xxxxxxxxx
    return RegExp(r'^(\+?20)?0?1[0125][0-9]{8}$').hasMatch(cleaned);
  }
}
