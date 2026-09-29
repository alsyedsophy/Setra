import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/features/home/presentation/widgets/product_card.dart';

class ProductSectionCategory extends StatelessWidget {
  const ProductSectionCategory({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.h_381,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) =>
            ProductCard().paddingHorizontal(AppSpacing.w_10),
      ),
    );
  }
}
