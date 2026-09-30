import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.banners});

  final List<BannerEntity>? banners;

  @override
  Widget build(BuildContext context) {
    final activeBanners = banners?.where((b) => b.isActive).toList() ?? [];

    if (activeBanners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: AppSpacing.h_300,
      child: PageView.builder(
        itemCount: activeBanners.length,
        itemBuilder: (context, index) {
          final banner = activeBanners[index];
          return _buildBannerItem(context, banner);
        },
      ),
    );
  }

  Widget _buildBannerItem(BuildContext context, BannerEntity banner) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppNetworkImage(
          imageUrl: banner.imageUrl,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.h_30,
          right: AppSpacing.w_20,
          left: AppSpacing.w_20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                banner.title,
                textAlign: TextAlign.center,
                style: context.textTheme.displayLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              if (banner.subtitle != null) ...[
                AppSpacing.h_8.hSpace,
                Text(
                  banner.subtitle!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ],
              if (banner.actionLabel != null &&
                  banner.actionType != BannerActionType.none) ...[
                AppSpacing.h_12.hSpace,
                Container(
                  height: AppSpacing.h_40,
                  width: AppSpacing.w_128,
                  decoration: BoxDecoration(
                    borderRadius: AppSpacing.r_4.rAll,
                    color: context.colorScheme.primary,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    banner.actionLabel!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}