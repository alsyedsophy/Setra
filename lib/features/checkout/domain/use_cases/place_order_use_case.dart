import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/domain/repositories/address_repository.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';
import 'package:setra/features/cart/domain/use_cases/validate_and_sync_cart_use_case.dart';
import 'package:setra/features/checkout/domain/entities/checkout_request_entity.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/entities/order_shipping_address_entity.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';

class PlaceOrderUseCase {
  final CartRepository cartRepository;
  final AddressRepository addressRepository;
  final OrderRepository orderRepository;
  final ValidateAndSyncCartUseCase validateAndSyncCart;

  /// غيّر القيمة عند تحديد سياسة الشحن.
  final double shippingCost;

  PlaceOrderUseCase({
    required this.cartRepository,
    required this.addressRepository,
    required this.orderRepository,
    required this.validateAndSyncCart,
    this.shippingCost = 0,
  });

  Future<Either<Failure, OrderEntity>> call(
    CheckoutRequestEntity request,
  ) async {
    // 1. التأكد من أن العنوان موجود ضمن عناوين المستخدم.
    final addressesResult = await addressRepository.getAddresses();

    final addresses = addressesResult.fold((failure) => null, (value) => value);

    if (addresses == null) {
      return addressesResult.fold(
        (failure) => Left(failure),
        (_) =>
            Left(ValidationFailure('addresses_unavailable', 'address_error')),
      );
    }

    final AddressEntity selectedAddress = request.shippingAddress;
    final addressExists = addresses.any(
      (address) => address.id == selectedAddress.id,
    );

    if (!addressExists) {
      return Left(
        ValidationFailure('invalid_shipping_address', 'address_not_found'),
      );
    }

    // 2. الحصول على أحدث نسخة من السلة.
    final CartEntity cart = await cartRepository.getCartItems().first;

    if (cart.items.isEmpty) {
      return Left(ValidationFailure('cart_is_empty', 'empty_cart'));
    }

    // 3. التحقق من المنتجات وتحديث الأسعار والكميات.
    final validationResult = await validateAndSyncCart(cart);

    final syncedData = validationResult.fold(
      (failure) => null,
      (result) => result,
    );

    if (syncedData == null) {
      return validationResult.fold(
        (failure) => Left(failure),
        (_) => Left(ValidationFailure('cart_validation_failed', 'cart_error')),
      );
    }

    final syncedCart = syncedData.updatedCart;
    final productsMap = syncedData.products;

    if (syncedCart.items.isEmpty) {
      return Left(
        ValidationFailure('cart_has_no_available_items', 'empty_cart'),
      );
    }

    // 4. تحويل العناصر إلى نسخة ثابتة داخل الطلب.
    final orderItems = <OrderItemEntity>[];
    double subtotal = 0;
    double discount = 0;

    for (final item in syncedCart.items) {
      final product = productsMap[item.productId];

      if (product == null) {
        return Left(ValidationFailure('product_unavailable', 'product_error'));
      }

      final unitPrice = product.finalPrice;

      subtotal += product.price * item.quantity;
      discount += (product.price - unitPrice) * item.quantity;

      orderItems.add(
        OrderItemEntity(
          productId: item.productId,
          variantId: item.variantId,
          productName: product.name,
          imageUrl: item.imageUrl,
          color: item.color,
          size: item.size,
          quantity: item.quantity,
          unitPrice: unitPrice,
          totalPrice: unitPrice * item.quantity,
        ),
      );
    }

    // 5. إنشاء الطلب باستخدام OrderEntity الموجود.
    final now = DateTime.now();

    final order = OrderEntity(
      id: '',
      userId: selectedAddress.userId,
      items: orderItems,
      shippingAddress: OrderShippingAddressEntity(
        addressId: selectedAddress.id,
        fullName: selectedAddress.fullName,
        phone: selectedAddress.phone,
        city: selectedAddress.city,
        area: selectedAddress.area,
        street: selectedAddress.street,
        building: selectedAddress.building,
        notes: selectedAddress.notes,
      ),
      subtotal: subtotal,
      discount: discount,
      shippingCost: shippingCost,
      total: subtotal - discount + shippingCost,
      orderStatus: OrderStatus.pending,
      paymentStatus: PaymentStatus.pending,
      paymentMethod: request.paymentMethod,
      createdAt: now,
    );

    final createResult = await orderRepository.createOrder(order);

    // 6. تفريغ السلة بعد نجاح إنشاء الطلب فقط.
    return createResult.fold((failure) => Left(failure), (createdOrder) {
      cartRepository.clearCart();
      return Right(createdOrder);
    });
  }
}
