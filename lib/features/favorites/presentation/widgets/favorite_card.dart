import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/presentation/widgets/favorite_button.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({super.key, required this.favoriteItem});

  final FavoriteItem favoriteItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.w_256,
      height: AppSpacing.h_300,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onPrimary,
          borderRadius: AppSpacing.r_12.rTop,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: AppSpacing.r_12.rAll,
                  child: AppNetworkImage(
                    imageUrl: favoriteItem.imageUrl,
                    fit: BoxFit.cover,
                    height: AppSpacing.h_230,
                  ),
                ),
                Positioned(
                  top: AppSpacing.h_8,
                  right: AppSpacing.w_8,
                  child: FavoriteButton(item: favoriteItem),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.h_8),
            Text(
              favoriteItem.name,
              style: AppTextStyles.lightTextTheme.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.h_4),
            Text(
              '\$${favoriteItem.price.toStringAsFixed(2)}',
              style: AppTextStyles.lightTextTheme.bodyLarge!.copyWith(
                color: LightColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
