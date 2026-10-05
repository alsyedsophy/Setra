import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/home/domain/entities/category_entity.dart';
import 'package:setra/features/home/presentation/widgets/title_section.dart';

class CategoryBanner extends StatelessWidget {
  const CategoryBanner({super.key, required this.category, this.height});
  final CategoryEntity category;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppNetworkImage(
          imageUrl: category.imageUrl,
          fit: BoxFit.cover,
          height: height ?? AppSpacing.h_248,
          borderRadius: 0,
        ),
        AppSpacing.h_4.hSpace,
        TitleSection(
          title: category.name,
          onTap: () =>
              context.pushNamed(RoutePaths.productsName, extra: category.id),
        ),
      ],
    );
  }
}
