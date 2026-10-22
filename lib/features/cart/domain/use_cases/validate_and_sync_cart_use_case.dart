import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/entities/cart_validation_result.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/products_variant.dart';
import 'package:setra/features/products/domain/usecases/get_product_by_id_use_case.dart';

/// هذه هى اساس التحقق من المنتجات داخل الكارت والمنتجات

class ValidateAndSyncCartUseCase {
  final CartRepository cartRepository;
  final GetProductByIdUseCase getProductById;

  ValidateAndSyncCartUseCase({
    required this.cartRepository,
    required this.getProductById,
  });

  Future<Either<Failure, CartValidationResult>> call(CartEntity cart) async {
    if (cart.items.isEmpty) {
      return Right(CartValidationResult(updatedCart: cart, changes: const []));
    }

    final List<CartItemEntity> syncedItems = [];
    final List<CartItemChange> changes = [];

    for (final item in cart.items) {
      final productResult = await getProductById(item.productId);

      final handled = await productResult.fold<Future<_ItemHandleResult>>((
        failure,
      ) async {
        // المنتج مش موجود أو فشل الجلب → احذف العنصر
        changes.add(
          CartItemChange(
            itemId: item.id,
            productId: item.productId,
            type: CartItemChangeType.productRemoved,
            message: 'تم إزالة منتج غير متاح من السلة',
          ),
        );
        return const _ItemHandleResult(item: null);
      }, (product) async => _validateItem(item, product, changes));

      if (handled.item != null) {
        syncedItems.add(handled.item!);
      }
    }

    // إعادة حساب الإجماليات
    final totalPrice = syncedItems.fold<double>(
      0.0,
      (sum, item) => sum + item.price,
    );
    final totalQuantity = syncedItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final updatedCart = CartEntity(
      id: cart.id,
      totalPrice: totalPrice,
      totalQuantity: totalQuantity,
      items: syncedItems,
    );

    // لو مفيش تغييرات حقيقية في البيانات، متعملش كتابة على Firestore
    final needsWrite =
        changes.isNotEmpty || !_cartItemsEqual(cart.items, syncedItems);

    if (needsWrite) {
      final saveResult = await cartRepository.replaceCart(updatedCart);
      return saveResult.fold(
        (failure) => Left(failure),
        (_) => Right(
          CartValidationResult(updatedCart: updatedCart, changes: changes),
        ),
      );
    }

    return Right(
      CartValidationResult(updatedCart: updatedCart, changes: changes),
    );
  }

  Future<_ItemHandleResult> _validateItem(
    CartItemEntity item,
    ProductEntity product,
    List<CartItemChange> changes,
  ) async {
    // 1) إيجاد الـ variant (بالـ variantId أولاً ثم باللون)
    ProductsVariant? variant;
    try {
      variant = product.variants.firstWhere((v) => v.id == item.variantId);
    } catch (_) {
      try {
        variant = product.variants.firstWhere((v) => v.color == item.color);
      } catch (_) {
        variant = null;
      }
    }

    if (variant == null) {
      changes.add(
        CartItemChange(
          itemId: item.id,
          productId: item.productId,
          type: CartItemChangeType.variantUnavailable,
          message: 'اللون المطلوب لم يعد متاحًا',
        ),
      );
      return const _ItemHandleResult(item: null);
    }

    // 2) إيجاد المقاس
    VariantSize? size;
    try {
      size = variant.sizes.firstWhere((s) => s.size == item.size);
    } catch (_) {
      size = null;
    }

    if (size == null || !size.isActive || size.stock <= 0) {
      changes.add(
        CartItemChange(
          itemId: item.id,
          productId: item.productId,
          type: CartItemChangeType.variantUnavailable,
          message: size == null
              ? 'المقاس المطلوب لم يعد متاحًا'
              : 'المقاس غير متاح حاليًا',
        ),
      );
      return const _ItemHandleResult(item: null);
    }

    // 3) الكمية
    int newQuantity = item.quantity;
    if (item.quantity > size.stock) {
      newQuantity = size.stock;
      changes.add(
        CartItemChange(
          itemId: item.id,
          productId: item.productId,
          type: CartItemChangeType.quantityReduced,
          message: 'تم تقليل الكمية إلى ${size.stock} بسبب نفاد المخزون',
          oldQuantity: item.quantity,
          newQuantity: newQuantity,
        ),
      );
    }

    // 4) السعر (unit = product.finalPrice ، line total = unit * qty)
    // في الكارت: item.price = إجمالي السطر
    final currentUnitPrice = item.quantity > 1
        ? item.price / item.quantity
        : item.price;
    final newUnitPrice = product.finalPrice;
    final newLinePrice = newUnitPrice * newQuantity;

    // نعتبر فرق صغير بسبب double
    final priceChanged = (currentUnitPrice - newUnitPrice).abs() > 0.009;

    if (priceChanged) {
      changes.add(
        CartItemChange(
          itemId: item.id,
          productId: item.productId,
          type: CartItemChangeType.priceChanged,
          message:
              'تم تحديث السعر من ${currentUnitPrice.toStringAsFixed(2)} إلى ${newUnitPrice.toStringAsFixed(2)}',
          oldPrice: currentUnitPrice,
          newPrice: newUnitPrice,
        ),
      );
    }

    final syncedItem = item.copyWith(
      quantity: newQuantity,
      price: newLinePrice,
      // تحديث الصورة لو اتغيرت
      imageUrl: variant.imageUlrs.isNotEmpty
          ? variant.imageUlrs.first
          : item.imageUrl,
    );

    return _ItemHandleResult(item: syncedItem);
  }

  bool _cartItemsEqual(List<CartItemEntity> a, List<CartItemEntity> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id ||
          a[i].quantity != b[i].quantity ||
          (a[i].price - b[i].price).abs() > 0.009) {
        return false;
      }
    }
    return true;
  }
}

class _ItemHandleResult {
  final CartItemEntity? item;
  const _ItemHandleResult({this.item});
}
