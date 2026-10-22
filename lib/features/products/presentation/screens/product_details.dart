import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/responsive/responsive.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/products_variant.dart';
import 'package:setra/features/products/presentation/widgets/add_to_cart_button.dart';
import 'package:setra/features/products/presentation/widgets/product_colors.dart';
import 'package:setra/features/products/presentation/widgets/product_image_page.dart';
import 'package:setra/features/products/presentation/widgets/product_name_and_price.dart';
import 'package:setra/features/products/presentation/widgets/product_quantity.dart';
import 'package:setra/features/products/presentation/widgets/product_review.dart';
import 'package:setra/features/products/presentation/widgets/product_size.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductsVariant _selectedVariant;
  VariantSize? _selectedSize; // يبدأ بـ null دائماً
  int intialQuantity = 1;

  // قائمة تجميع كافة الصور مرتبة حسب الفاريانتس
  late final List<String> _allVariantsImages;
  // خريطة لمعرفة بداية index صور كل فاريانت داخل القائمة الكلية
  late final Map<String, int> _variantImageStartIndex;

  @override
  void initState() {
    super.initState();
    // اختيار أول Variant بشكل افتراضي
    _selectedVariant = widget.productEntity.variants.first;
    _selectedSize = null; // التأكيد على كونه null في البداية

    _prepareAllImagesAndIndices();
  }

  void _prepareAllImagesAndIndices() {
    _allVariantsImages = [];
    _variantImageStartIndex = {};

    for (var variant in widget.productEntity.variants) {
      if (variant.imageUlrs.isNotEmpty) {
        // تسليط الضوء على أول صورة لهذا الفاريانت داخل القائمة الشاملة
        _variantImageStartIndex[variant.id] = _allVariantsImages.length;
        _allVariantsImages.addAll(variant.imageUlrs);
      }
    }
  }

  void _onColorSelected(ProductsVariant variant) {
    setState(() {
      _selectedVariant = variant;
      _selectedSize = null; // تصفير المقاس عند اختيار لون جديد
      intialQuantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final targetImageIndex = _variantImageStartIndex[_selectedVariant.id] ?? 0;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomHomeDrawer(),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(targetImageIndex),
        desktop: _buildDesktopLayout(targetImageIndex),
      ),
    );
  }

  Widget _buildMobileLayout(int targetImageIndex) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImagePage(
            images: _allVariantsImages,
            targetIndex: targetImageIndex,
          ),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(int targetImageIndex) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: ProductImagePage(
              images: _allVariantsImages,
              targetIndex: targetImageIndex,
            ),
          ),
        ),
        Expanded(flex: 5, child: SingleChildScrollView(child: _buildDetails())),
      ],
    );
  }

  Widget _buildDetails() {
    final double horizontalPadding = context.responsive(
      mobile: AppSpacing.w_16,
      desktop: AppSpacing.w_40,
    );
    final double topPadding = context.responsive(
      mobile: AppSpacing.h_48,
      desktop: AppSpacing.h_32,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topPadding.hSpace,
        ProductNameAndPrice(productEntity: widget.productEntity),
        AppSpacing.h_24.hSpace,

        // اختيار اللون
        ProductColors(
          variants: widget.productEntity.variants,
          selectedVariant: _selectedVariant,
          onVariantSelected: _onColorSelected,
        ),
        AppSpacing.h_24.hSpace,

        // اختيار المقاس (يتحكم في selectedSize الذي يبدأ بـ null)
        ProductSize(
          sizes: _selectedVariant.sizes,
          selectedSize: _selectedSize,
          onSelectedSize: (size) => setState(() {
            log('Size');
            _selectedSize = size;
            intialQuantity = 1;
          }),
        ),
        AppSpacing.h_24.hSpace,

        ProductQuantity(
          key: ValueKey(
            '${_selectedVariant.id}_${_selectedSize?.id ?? 'none'}',
          ),
          initialQuantity: intialQuantity,
          onChange: (quantity) {
            setState(() {
              intialQuantity = quantity;
            });
            // log(intialQuantity.toString());
          },
          variantStock: _selectedSize != null ? _selectedSize!.stock : 0,
        ),
        AppSpacing.h_24.hSpace,

        ProductReview(
          reviewCount: widget.productEntity.reviewCount,
          rating: widget.productEntity.rating,
        ),
        AppSpacing.h_50.hSpace,

        AddToCartButton(
          selectedSize: _selectedSize,
          productEntity: widget.productEntity,
          selectedVariant: _selectedVariant,
          intialQuantity: intialQuantity,
        ),
        AppSpacing.h_50.hSpace,
      ],
    ).paddingHorizontal(horizontalPadding);
  }
}
