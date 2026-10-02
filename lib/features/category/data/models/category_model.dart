import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.nameEn,
    super.description,
    required super.imageUrl,
    super.displayOrder,
    super.isActive,
    super.isFeatured,
    super.productCount,
    required super.createdAt,
    super.updatedAt,
  });

  // ============ Parsing ============

  factory CategoryModel.fromFirestore(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    return CategoryModel(
      id: (map['id'] as String?) ?? docId ?? '',
      name: map['name'] as String? ?? '',
      nameEn: map['nameEn'] as String?,
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String? ?? '',
      displayOrder: _toInt(map['displayOrder']),
      isActive: map['isActive'] as bool? ?? true,
      isFeatured: map['isFeatured'] as bool? ?? false,
      productCount: _toInt(map['productCount']),
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      nameEn: entity.nameEn,
      description: entity.description,
      imageUrl: entity.imageUrl,
      displayOrder: entity.displayOrder,
      isActive: entity.isActive,
      isFeatured: entity.isFeatured,
      productCount: entity.productCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'description': description,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'productCount': productCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }

  // ============ Parsing Helpers ============

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
