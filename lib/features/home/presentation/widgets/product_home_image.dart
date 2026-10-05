import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class ProductHomeImage extends StatelessWidget {
  const ProductHomeImage({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.w_200,
      child: ClipRRect(
        borderRadius: AppSpacing.r_12.rAll,
        child: AppNetworkImage(
          imageUrl: productEntity.mainImage,
          fit: BoxFit.cover,
          height: AppSpacing.h_300,
        ),
      ),
    ).onTap(
      () => context.pushNamed(
        RoutePaths.productsDetailsName,
        extra: productEntity,
      ),
    );
  }
}
