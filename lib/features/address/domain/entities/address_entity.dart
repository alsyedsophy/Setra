import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String city;
  final String area;
  final String street;
  final String? building;
  final String? notes;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.area,
    required this.street,
    this.building,
    this.notes,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  AddressEntity copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phone,
    String? city,
    String? area,
    String? street,
    String? building,
    String? notes,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearBuilding = false,
    bool clearNotes = false,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      area: area ?? this.area,
      street: street ?? this.street,
      building: clearBuilding ? null : (building ?? this.building),
      notes: clearNotes ? null : (notes ?? this.notes),
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// سطر واحد للعرض في القوائم
  String get shortLabel => '$city - $area';

  /// العنوان الكامل
  String get fullAddress {
    final parts = <String>[
      street,
      if (building != null && building!.trim().isNotEmpty) building!,
      area,
      city,
    ];
    return parts.join('، ');
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    phone,
    city,
    area,
    street,
    building,
    notes,
    isDefault,
    createdAt,
    updatedAt,
  ];
}
