import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';

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
          child: Text(
            "VIEW ALL",
            style: context.textTheme.titleSmall,
          ).onTap(onTap),
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_10);
  }
}

Future<void> seedProductsToFirebase() async {
  final firestore = FirebaseFirestore.instance;

  // بيانات منتج تجريبي مطابق تماماً للـ Entity
  final Map<String, dynamic> sampleProduct = {
    'id': 'prod_2',
    'name': 'تيشيرت رياضي رجالي',
    'description':
        'تيشيرت مخصص للجري وتمارين الجيم، خامات عالية الجودة تضمن الراحة.',
    'price': 600.0,
    'finalPrice': 540.0,
    'discountPercentage': 10,
    'hasDiscount': true,
    'imageUrls': [
      'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
    ],
    'categoryId': 'mens_clothing',
    'gender': 'men', // يجب أن تطابق الـ enum (men أو kids)
    'brand': 'Addidas',
    'tags': ['sports', 'gym', 'summer'],
    'availableSizes': ['M', 'L', 'XL'],
    'availableColors': ['#000000', '#FFFFFF', '#ff0044'],
    'newArrival': true,
    'featured': true,
    'stock': 15,
    'rating': 4.8,
    'reviewCount': 5,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': null,
  };

  try {
    // حفظ المنتج في collection اسمها 'products' ونستعمل الـ id كمعرف للمستند
    await firestore.collection('products').doc('prod_3').set(sampleProduct);
    print('تم رفع المنتج بنجاح إلى Firebase!');
  } catch (e) {
    print('حدث خطأ أثناء الرفع: $e');
  }
}

Future<void> seedCategoryToFirebase() async {
  final firestore = FirebaseFirestore.instance;

  // بيانات تصنيف تجريبي مطابق تماماً للـ CategoryEntity
  final Map<String, dynamic> sampleCategory = {
    'id': 'cat_mens_clothing',
    'name': 'ملابس رجالي',
    'nameEn': 'Men Clothing',
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
        .doc('cat_mens_clothing')
        .set(sampleCategory);
    print('تم رفع التصنيف بنجاح إلى Firebase!');
  } catch (e) {
    print('حدث خطأ أثناء رفع التصنيف: $e');
  }
}
