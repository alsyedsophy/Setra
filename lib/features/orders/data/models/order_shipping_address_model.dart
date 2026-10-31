import 'package:setra/features/orders/domain/entities/order_shipping_address_entity.dart';

class OrderShippingAddressModel extends OrderShippingAddressEntity {
  const OrderShippingAddressModel({
    super.addressId,
    required super.fullName,
    required super.phone,
    required super.city,
    required super.area,
    required super.street,
    super.building,
    super.notes,
  });

  /// Factory للتحويل من Map قادمة من Firestore (أو من Map داخل وثيقة الطلب)
  factory OrderShippingAddressModel.fromFirestore(Map<String, dynamic> map) {
    return OrderShippingAddressModel(
      addressId: map['addressId'] as String?,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      area: map['area'] ?? '',
      street: map['street'] ?? '',
      building: map['building'] as String?,
      notes: map['notes'] as String?,
    );
  }

  /// التحويل إلى Map لتخزينها في Firestore (سواء كـ Sub-document أو داخل Order Document)
  Map<String, dynamic> toFirestore() {
    return {
      'addressId': addressId,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'area': area,
      'street': street,
      'building': building,
      'notes': notes,
    };
  }

  /// الإنشاء من الـ Entity الأصلي (مفيد جداً عند حفظ الطلب)
  factory OrderShippingAddressModel.fromEntity(
    OrderShippingAddressEntity entity,
  ) {
    return OrderShippingAddressModel(
      addressId: entity.addressId,
      fullName: entity.fullName,
      phone: entity.phone,
      city: entity.city,
      area: entity.area,
      street: entity.street,
      building: entity.building,
      notes: entity.notes,
    );
  }
}
