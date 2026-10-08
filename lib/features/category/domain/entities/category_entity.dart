import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final String imageUrl;
  final String gender;
  final int displayOrder;
  final bool isActive;
  final bool isFeatured;
  final int productCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    required this.imageUrl,
    required this.gender,
    this.displayOrder = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.productCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  bool get hasImage => imageUrl.trim().isNotEmpty;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? description,
    String? imageUrl,
    String? gender,
    int? displayOrder,
    bool? isActive,
    bool? isFeatured,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNameEn = false,
    bool clearDescription = false,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: clearNameEn ? null : (nameEn ?? this.nameEn),
      description: clearDescription ? null : (description ?? this.description),
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      productCount: productCount ?? this.productCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameEn,
    description,
    imageUrl,
    gender,
    displayOrder,
    isActive,
    isFeatured,
    productCount,
    createdAt,
    updatedAt,
  ];
}
