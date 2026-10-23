import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';

class GetDefaultAddressUseCase {
  final AddressRepository repository;

  GetDefaultAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity?>> call() {
    return repository.getDefaultAddress();
  }
}
