import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, this.productEntity});
  final ProductEntity? productEntity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.h_433,
      width: AppSpacing.w_256,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/product.png",
            height: AppSpacing.h_340,
            fit: BoxFit.contain,
          ).expanded,
          AppSpacing.h_10.hSpace,
          Text("Structural Hoodie 01", style: context.textTheme.bodyMedium),
          AppSpacing.h_4.hSpace,
          Text("${240.00} USD", style: context.textTheme.labelMedium),
        ],
      ),
    );
  }
}
