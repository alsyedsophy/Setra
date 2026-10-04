import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/presentation/widgets/product_colors.dart';
import 'package:setra/features/products/presentation/widgets/product_image_page.dart';
import 'package:setra/features/products/presentation/widgets/product_name_and_price.dart';
import 'package:setra/features/products/presentation/widgets/product_review.dart';
import 'package:setra/features/products/presentation/widgets/product_size.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomHomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: M,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImagePage(images: widget.productEntity.imageUrls),
            AppSpacing.h_48.hSpace,
            ProductNameAndPrice(productEntity: widget.productEntity),
            AppSpacing.h_24.hSpace,
            ProductColors(
              colors: widget.productEntity.availableColors,
              onColorSeleted: (color) => setState(() {
                selectedColor = color;
              }),
            ),
            AppSpacing.h_24.hSpace,
            ProductSize(
              sizes: widget.productEntity.availableSizes,
              onSelectedSize: (size) => setState(() {
                selectedSize = size;
              }),
            ),
            AppSpacing.h_24.hSpace,
            ProductReview(
              reviewCount: widget.productEntity.reviewCount,
              rating: widget.productEntity.rating,
            ),

            AppSpacing.h_50.hSpace,
          ],
        ),
      ),
    );
  }
}
