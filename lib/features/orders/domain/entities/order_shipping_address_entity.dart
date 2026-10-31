import 'package:equatable/equatable.dart';

class OrderShippingAddressEntity extends Equatable {
  final String? addressId;
  final String fullName;
  final String phone;
  final String city;
  final String area;
  final String street;
  final String? building;
  final String? notes;

  const OrderShippingAddressEntity({
    this.addressId,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.area,
    required this.street,
    this.building,
    this.notes,
  });

  @override
  List<Object?> get props => [
    addressId,
    fullName,
    phone,
    city,
    area,
    street,
    building,
    notes,
  ];
}
