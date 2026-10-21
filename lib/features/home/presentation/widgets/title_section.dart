import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/features/products/data/models/product_model.dart';
import 'package:setra/features/products/data/models/product_variant_model.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(title, style: context.textTheme.headlineLarge),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text("VIEW ALL", style: context.textTheme.titleSmall).onTap(
            () {
              // seedTestProduct(FirebaseFirestore.instance);
              seedCategoryToFirebase();
            },
          ),
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_10);
  }
}

Future<void> seedTestProduct(FirebaseFirestore firestore) async {
  try {
    // 1. إنشاء فاريانت اللون الأحمر مع عدة مقاسات مختلفة
    final sampleVariant = ProductsVariantModel(
      id: 'variant_red_01',
      color: 'Red',
      imageUlrs: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      ],
      sizes: [
        const VariantSizeModel(
          id: 'size_s_01',
          size: 'Small',
          stock: 3, // 3 قطع متاحة من مقاس Small
          isActive: true,
        ),

        const VariantSizeModel(
          id: 'size_xl_01',
          size: 'Exstra Large',
          stock: 2, // نفد المخزون من مقاس Large مثلاً
          isActive: false,
        ),
      ],
    );
    final sampleVariant1 = ProductsVariantModel(
      id: 'variant_blue_01',
      color: 'blue',
      imageUlrs: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      ],
      sizes: [
        const VariantSizeModel(
          id: 'size_m_01',
          size: 'Medium',
          stock: 5, // 5 قطع متاحة من مقاس Medium
          isActive: true,
        ),
        const VariantSizeModel(
          id: 'size_l_01',
          size: 'Large',
          stock: 2, // نفد المخزون من مقاس Large مثلاً
          isActive: false,
        ),
        const VariantSizeModel(
          id: 'size_xl_01',
          size: 'Exstra Large',
          stock: 2, // نفد المخزون من مقاس Large مثلاً
          isActive: false,
        ),
      ],
    );

    // 2. إنشاء نموذج المنتج (ProductModel)
    final testProduct = ProductModel(
      id: 'prod_test_003',
      name: 'Classic Oversized Cotton T-Shirt',
      description: 'تيشيرت قطني فاخر بتصميم عصري مريح ومناسب لجميع الأوقات.',
      price: 150.0,
      finalPrice: 120.0,
      discountPercentage: 20,
      hasDiscount: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      ],
      categoryId: 'new_arrivals',
      gender: ProductGender.kids,
      brand: 'Setra Originals',
      tags: ['fashion', 'tshirt', 'cotton', 'summer'],
      variants: [sampleVariant, sampleVariant1],
      newArrival: true,
      featured: false,
      stock: 14, // الإجمالي الكلي للمخزون (3 + 5 + 0)
      rating: 4.8,
      reviewCount: 24,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // 3. رفع المنتج إلى مجموعة 'products'
    await firestore
        .collection('products')
        .doc(testProduct.id)
        .set(testProduct.toFirestore());

    print('✅ تمت إضافة المنتج التجريبي متعدد المقاسات بنجاح إلى Firestore!');
  } catch (e) {
    print('❌ حدث خطأ أثناء رفع المنتج: $e');
  }
}

Future<void> seedCategoryToFirebase() async {
  final firestore = FirebaseFirestore.instance;

  // بيانات تصنيف تجريبي مطابق تماماً للـ CategoryEntity
  final Map<String, dynamic> sampleCategory = {
    'id': 'cat_clothing_01',
    'name': 'ملابس رجالى',
    'nameEn': 'Mens Clothing',
    'description': 'تشكيلة واسعة من الملابس الرجالية العصرية والكاجوال.',
    'imageUrl': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
    'displayOrder': 1,
    'isActive': true,
    'isFeatured': true,
    'productCount': 12,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': null,
  };

  try {
    // حفظ التصنيف في collection اسمها 'categories' ونستعمل الـ id كمعرف للمستند
    await firestore
        .collection('categories')
        .doc('cat_clothing_01')
        .set(sampleCategory);
    print('تم رفع التصنيف بنجاح إلى Firebase!');
  } catch (e) {
    print('حدث خطأ أثناء رفع التصنيف: $e');
  }
}
