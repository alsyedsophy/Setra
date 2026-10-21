import 'package:equatable/equatable.dart';

class ProductsVariant extends Equatable {
  final String id;
  final String color;
  final List<String> imageUlrs;
  final List<VariantSize> sizes;

  const ProductsVariant({
    required this.id,
    required this.color,
    required this.imageUlrs,
    required this.sizes,
  });

  ProductsVariant copyWith({
    String? id,
    String? color,
    List<String>? imageUlrs,
    List<VariantSize>? sizes,
  }) => ProductsVariant(
    id: id ?? this.id,
    color: color ?? this.color,
    imageUlrs: imageUlrs ?? this.imageUlrs,
    sizes: sizes ?? this.sizes,
  );

  @override
  List<Object?> get props => [id, color, imageUlrs, sizes];
}

class VariantSize extends Equatable {
  final String id;
  final String size;
  final int stock;
  final bool isActive;

  const VariantSize({
    required this.id,
    required this.size,
    required this.stock,
    required this.isActive,
  });

  VariantSize copyWith({
    String? id,
    String? size,
    int? stock,
    bool? isActive,
  }) => VariantSize(
    id: id ?? this.id,
    size: size ?? this.size,
    stock: stock ?? this.stock,
    isActive: isActive ?? this.isActive,
  );

  @override
  List<Object?> get props => [id, size, stock, isActive];
}
