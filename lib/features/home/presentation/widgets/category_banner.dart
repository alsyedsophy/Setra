import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class CategoryBanner extends StatelessWidget {
  const CategoryBanner({
    super.key,
    this.padding,
    this.height,
    this.paddingRL,
    this.paddingBottom,
    this.lableColor,
    this.titleColor,
  });
  final double? padding;
  final double? height;
  final double? paddingRL;
  final double? paddingBottom;
  final Color? lableColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: AppSpacing.r_12.rAll,
          child: Image.asset(
            "assets/images/hoddis.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: height ?? 200,
          ),
        ).paddingHorizontal(padding ?? AppSpacing.w_12),
        Positioned(
          bottom: paddingBottom ?? 20,
          right: paddingRL ?? 60,
          left: paddingRL ?? 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "FASHOIN",
                  style: context.textTheme.titleLarge!.copyWith(
                    color: lableColor ?? context.colorScheme.primary,
                  ),
                ),
              ),
              AppSpacing.h_16.hSpace,
              Text(
                "HODDIES",
                style: context.textTheme.displayLarge!.copyWith(
                  color: titleColor ?? context.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
