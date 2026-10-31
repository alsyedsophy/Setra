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

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final userId = _uid;

      final docRef = _ordersCollection.doc();
      log(docRef.toString());
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
      log(document.toString());

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(document);

        if (!snapshot.exists) {
          transaction.set(document, newOrder.toFirestore());
        }
      });

      return order;
    } on AuthException {
      rethrow;
    } catch (e) {
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
        yield snapshot.docs
            .map(
              (document) =>
                  OrderModel.fromFirestore(document.data(), document.id),
            )
            .toList();
      }
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      _uid; // نتأكد إن في user

      await _ordersCollection.doc(orderId).update({
        'orderStatus': OrderStatus.cancelled.name,
        'paymentStatus': PaymentStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to cancel order');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
