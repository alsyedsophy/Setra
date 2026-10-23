import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.phone,
    required super.city,
    required super.area,
    required super.street,
    super.building,
    super.notes,
    super.isDefault,
    required super.createdAt,
    super.updatedAt,
  });

  factory AddressModel.fromFirestore(
    Map<String, dynamic> json, {
    required String id,
  }) {
    return AddressModel(
      id: id,
      userId: json['user_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      street: json['street'] as String? ?? '',
      building: json['building'] as String?,
      notes: json['notes'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'city': city,
      'area': area,
      'street': street,
      'building': building,
      'notes': notes,
      'is_default': isDefault,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      fullName: entity.fullName,
      phone: entity.phone,
      city: entity.city,
      area: entity.area,
      street: entity.street,
      building: entity.building,
      notes: entity.notes,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
