import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  Future<Either<Failure, AddressEntity?>> getDefaultAddress();

  Future<Either<Failure, AddressEntity>> addAddress(AddressEntity address);

  Future<Either<Failure, AddressEntity>> updateAddress(AddressEntity address);

  Future<Either<Failure, void>> deleteAddress(String addressId);

  Future<Either<Failure, void>> setDefaultAddress(String addressId);
}
