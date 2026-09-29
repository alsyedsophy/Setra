import 'package:equatable/equatable.dart';

enum BannerActionType {
  product, // يفتح صفحة منتج معين
  category, // يفتح صفحة تصنيف معين
  externalLink, // يفتح رابط خارجي (موقع أو متصفح)
  none, // بانر إعلاني بحت بدون تفاعل
}

class BannerEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final BannerActionType actionType;
  final String? actionLabel;
  final String? targetId; // معرف المنتج أو القسم المستهدف (إذا وجد)
  final String? externalUrl; // الرابط الخارجي (إذا وجد)
  final int displayOrder; // لترتيب ظهور البانرات في الـ Slider
  final bool isActive; // هل البانر مفعل حالياً أم لا

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    required this.actionType,
    this.actionLabel,
    this.targetId,
    this.externalUrl,
    required this.displayOrder,
    required this.isActive,
  });

  BannerEntity copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? subtitle,
    BannerActionType? actionType,
    String? actionLabel,
    String? targetId,
    String? externalUrl,
    int? displayOrder,
    bool? isActive,
  }) {
    return BannerEntity(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      actionType: actionType ?? this.actionType,
      actionLabel: actionLabel ?? this.actionLabel,
      targetId: targetId ?? this.targetId,
      externalUrl: externalUrl ?? this.externalUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    imageUrl,
    title,
    subtitle,
    actionType,
    actionLabel,
    targetId,
    externalUrl,
    displayOrder,
    isActive,
  ];
}
