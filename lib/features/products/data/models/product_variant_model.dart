import 'package:setra/features/products/domain/entities/products_variant.dart';

class ProductsVariantModel extends ProductsVariant {
  const ProductsVariantModel({
    required super.id,
    required super.color,
    required super.imageUlrs,
    required super.sizes,
  });

  factory ProductsVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductsVariantModel(
      id: json['id'] as String,
      color: json['color'] as String,
      imageUlrs: List<String>.from(json['imageUlrs'] as List<dynamic>),
      sizes: (json['sizes'] as List<dynamic>)
          .map((e) => VariantSizeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'imageUlrs': imageUlrs,
      'sizes': sizes.map((e) => (e as VariantSizeModel).toJson()).toList(),
    };
  }

  factory ProductsVariantModel.fromEntity(ProductsVariant entity) {
    return ProductsVariantModel(
      id: entity.id,
      color: entity.color,
      imageUlrs: entity.imageUlrs,
      sizes: entity.sizes.map((e) => VariantSizeModel.fromEntity(e)).toList(),
    );
  }
}

class VariantSizeModel extends VariantSize {
  const VariantSizeModel({
    required super.id,
    required super.size,
    required super.stock,
    required super.isActive,
  });

  factory VariantSizeModel.fromJson(Map<String, dynamic> json) {
    return VariantSizeModel(
      id: json['id'] as String,
      size: json['size'] as String,
      stock: json['stock'] as int,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'size': size, 'stock': stock, 'isActive': isActive};
  }

  factory VariantSizeModel.fromEntity(VariantSize entity) {
    return VariantSizeModel(
      id: entity.id,
      size: entity.size,
      stock: entity.stock,
      isActive: entity.isActive,
    );
  }
}
