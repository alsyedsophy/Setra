import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    this.productCount = 0,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final int productCount;

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    int? productCount,
  }) =>
      CategoryEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        productCount: productCount ?? this.productCount,
      );

  @override
  List<Object?> get props => [id, name, imageUrl, description, productCount];
}