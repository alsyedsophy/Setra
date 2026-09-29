import 'package:equatable/equatable.dart';

class OffersEntity extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final int? discount;
  final int? lessThan;

  const OffersEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.lessThan,
  });

  OffersEntity copyWith(
    int? id,
    String? title,
    String? subtitle,
    int? discount,
    int? lessThan,
  ) => OffersEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    discount: discount ?? this.discount,
    lessThan: lessThan ?? this.lessThan,
  );

  @override
  List<Object?> get props => [id, title, subtitle, discount, lessThan];
}
