import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.banners});

  final List<BannerEntity>? banners;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/images/hoddis.png"),
        Positioned(
          bottom: 30,
          right: 20,
          left: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Discount\n 70 %",
                textAlign: TextAlign.center,
                style: context.textTheme.displayLarge!.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              AppSpacing.h_64.hSpace,
              Text(
                "ESSENTIAL\nCOLLECTION",
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge!.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              AppSpacing.h_12.hSpace,
              Container(
                height: AppSpacing.h_30,
                width: AppSpacing.w_100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.r_4),
                  color: context.colorScheme.primary,
                ),
                alignment: Alignment.center,
                child: Text(
                  "SHOP NOW",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
