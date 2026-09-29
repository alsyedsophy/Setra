import 'package:setra/features/home/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.imageUrl,
    required super.title,
    super.subtitle,
    required super.actionType,
    super.actionLabel,
    super.targetId,
    super.externalUrl,
    required super.displayOrder,
    required super.isActive,
  });

  factory BannerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BannerModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'],
      subtitle: data['subtitle'],
      actionType: _parseBannerActionType(data['actionType']),
      actionLabel: data['actionLabel'],
      targetId: data['targetId'],
      externalUrl: data['externalUrl'],
      displayOrder: (data['displayOrder'] ?? 0).toInt(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'actionType': actionType.name,
      'actionLabel': actionLabel,
      'targetId': targetId,
      'externalUrl': externalUrl,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      title: entity.title,
      subtitle: entity.subtitle,
      actionType: entity.actionType,
      actionLabel: entity.actionLabel,
      targetId: entity.targetId,
      externalUrl: entity.externalUrl,
      displayOrder: entity.displayOrder,
      isActive: entity.isActive,
    );
  }

  static BannerActionType _parseBannerActionType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'product':
        return BannerActionType.product;
      case 'category':
        return BannerActionType.category;
      case 'externallink':
        return BannerActionType.externalLink;
      case 'none':
      default:
        return BannerActionType.none;
    }
  }
}
