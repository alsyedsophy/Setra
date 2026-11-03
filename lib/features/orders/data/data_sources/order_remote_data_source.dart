import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/orders/data/models/order_model.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> getOrderById(String orderId);
  Future<List<OrderModel>> getUserOrders();
  Stream<OrderModel> watchOrder(String orderId);
  Stream<List<OrderModel>> watchUserOrders();
  Future<void> cancelOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  OrderRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      firestore.collection('orders');

  String get _uid {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw AuthException(message: 'User must be authenticated.');
    }

    return user.uid;
  }

  // ==================== Helper: خصم / إرجاع المخزون ====================
  Future<void> _updateStock({
    required Transaction transaction,
    required List<Map<String, dynamic>> items,
    required bool isDecrease,
  }) async {
    log('================ open Update Stock ==========');

    for (final item in items) {
      final productId = item['productId'] as String?;
      final variantId = item['variantId'] as String?;
      final size = item['size'] as String?;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 0;

      if (productId == null ||
          productId.isEmpty ||
          variantId == null ||
          variantId.isEmpty ||
          size == null ||
          size.isEmpty ||
          quantity <= 0) {
        continue;
      }

      final productRef = firestore.collection('products').doc(productId);
      final productSnapshot = await transaction.get(productRef);

      if (!productSnapshot.exists) {
        throw ServerException(message: 'Product not found: $productId');
      }

      final productData = productSnapshot.data()!;
      final variants = List<Map<String, dynamic>>.from(
        productData['variants'] ?? [],
      );

      final variantIndex = variants.indexWhere((v) => v['id'] == variantId);

      if (variantIndex == -1) {
        throw ServerException(
          message: 'Variant not found: $productId / $variantId',
        );
      }

      final variant = Map<String, dynamic>.from(variants[variantIndex]);
      final sizes = List<Map<String, dynamic>>.from(variant['sizes'] ?? []);

      // 2. نلاقي الـ Size جوه الـ Variant
      final sizeIndex = sizes.indexWhere((s) => s['size'] == size);

      if (sizeIndex == -1) {
        throw ServerException(
          message: 'Size not found: $productId / $variantId / $size',
        );
      }

      final sizeData = Map<String, dynamic>.from(sizes[sizeIndex]);
      final currentStock = (sizeData['stock'] as num?)?.toInt() ?? 0;

      log('================ current stock : $currentStock ==========');

      final newStock = isDecrease
          ? currentStock - quantity
          : currentStock + quantity;

      if (isDecrease && newStock < 0) {
        throw ServerException(
          message:
              'Insufficient stock for product $productId (variant: $variantId, size: $size)',
        );
      }

      // 3. نحدّث الـ stock بتاع الـ Size
      sizeData['stock'] = newStock;
      sizes[sizeIndex] = sizeData;

      // 4. نرجّع الـ sizes المعدّلة جوه الـ variant
      variant['sizes'] = sizes;
      variants[variantIndex] = variant;

      log('================ go to update stock in size ==========');

      // 5. نكتب الـ variants كلها تاني
      transaction.update(productRef, {
        'variants': variants,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final userId = _uid;
      log('================ User Error ==========');

      final docRef = _ordersCollection.doc();
      log(" ======================= $docRef =================");
      final newOrder = OrderModel(
        id: docRef.id,
        userId: userId,
        items: order.items,
        shippingAddress: order.shippingAddress,
        subtotal: order.subtotal,
        discount: order.discount,
        shippingCost: order.shippingCost,
        total: order.total,
        orderStatus: order.orderStatus,
        paymentStatus: order.paymentStatus,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      );

      final document = _ordersCollection.doc(newOrder.id);
      log(" ======================== $document ===========================");

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(document);
        log('================ Snapshot Error ${snapshot.exists} ==========');

        if (!snapshot.exists) {
          log('================ Snapshot Error ${!snapshot.exists} ==========');
          await _updateStock(
            transaction: transaction,
            items: newOrder.items.map((e) {
              return {
                'productId': e.productId,
                'variantId': e.variantId,
                'size': e.size,
                'quantity': e.quantity,
              };
            }).toList(),
            isDecrease: true,
          );
          log('================ Updated success  ==========');
          transaction.set(document, newOrder.toFirestore());
        }
      });

      return order;
    } on AuthException {
      rethrow;
    } catch (e) {
      log('================ cached Error $e ==========');
      throw ServerException(message: 'Faild to create order');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      _uid;
      final doc = await _ordersCollection.doc(orderId).get();
      if (!doc.exists || doc.data() == null) {
        throw ServerException(message: 'Order not found');
      }

      return OrderModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } on AuthException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get order');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders() async {
    try {
      final currentUserId = _uid;

      final snapshot = await _ordersCollection
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get user orders: ${e.toString()}',
      );
    }
  }

  @override
  Stream<OrderModel> watchOrder(String orderId) async* {
    try {
      final uid = _uid;
      await for (final snapshot in _ordersCollection.doc(orderId).snapshots()) {
        if (!snapshot.exists) {
          throw Exception('Order not found.');
        }

        final data = snapshot.data()!;

        if (data['userId'] != uid) {
          throw Exception('Access denied.');
        }

        yield OrderModel.fromFirestore(data, snapshot.id);
      }
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<OrderModel>> watchUserOrders() async* {
    try {
      final uid = _uid;

      await for (final snapshot
          in _ordersCollection.where('userId', isEqualTo: uid).snapshots()) {
        log('======================= snapshot error $snapshot');
        yield snapshot.docs.map((doc) {
          log('==================== doc Error ${doc.exists} ===========');
          return OrderModel.fromFirestore(doc.data(), doc.id);
        }).toList();
      }
    } on FirebaseException {
      rethrow;
    } catch (e) {
      log('========================== $e ==============');
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      _uid;

      await firestore.runTransaction((transaction) async {
        final orderRef = _ordersCollection.doc(orderId);
        final orderSnapshot = await transaction.get(orderRef);

        if (!orderSnapshot.exists) {
          throw ServerException(message: 'Order not found');
        }

        final orderData = orderSnapshot.data()!;

        // منع إلغاء الطلب أكتر من مرة
        if (orderData['orderStatus'] == OrderStatus.cancelled.name) {
          throw ServerException(message: 'Order already cancelled');
        }

        final items = (orderData['items'] as List<dynamic>? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        // 1. إرجاع المخزون
        await _updateStock(
          transaction: transaction,
          items: items,
          isDecrease: false,
        );

        // 2. تغيير حالة الطلب
        transaction.update(orderRef, {
          'orderStatus': OrderStatus.cancelled.name,
          'paymentStatus': PaymentStatus.cancelled.name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to cancel order');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
