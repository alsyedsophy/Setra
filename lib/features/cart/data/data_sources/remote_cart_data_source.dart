import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/features/cart/data/models/cart_model.dart';

abstract class RemoteCartDataSource {
  Future<void> addToCart(CartItemModel cartItem);
  Future<void> removeFromCart(String itemId);
  Future<void> updateCartItem(String itemId, int quantity);
  Stream<CartModel> getCartItems();
  Future<void> clearCart();
}

class RemoteCartDataSourceImpl implements RemoteCartDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RemoteCartDataSourceImpl({required this.firestore, required this.auth});

  String get _uid {
    final uid = auth.currentUser?.uid;
    log('Check current user');
    if (uid == null || uid.isEmpty) {
      log('current user not found');
      throw AuthException(message: 'User must be authenticated');
    }
    log('flund current user and userId is :$uid');
    return uid;
  }

  DocumentReference<Map<String, dynamic>> get _cartDoc =>
      firestore.collection('cart').doc(_uid);

  @override
  Future<void> addToCart(CartItemModel cartItem) async {
    try {
      log('will run transaction');
      await firestore.runTransaction((transaction) async {
        log('run transaction');
        final snapshot = await transaction.get(_cartDoc);
        log('get snapshot');
        if (!snapshot.exists) {
          log('snapshot not exists');
          final newCart = CartModel(
            id: _uid,
            totalPrice: cartItem.price * cartItem.quantity,
            totalQuantity: cartItem.quantity,
            items: [cartItem],
          );
          log('will set the model');
          transaction.set(_cartDoc, newCart.toFireStore());
          log('set model success');
        } else {
          log('snapshot is exists');
          final existingCart = CartModel.fromFireStore(snapshot.data()!);
          final updatedItems = List<CartItemModel>.from(existingCart.items);

          // Check if the item already exists in the cart
          log('check the item already in the cart');
          final existingItemIndex = updatedItems.indexWhere(
            (item) => item.id == cartItem.id,
          );

          if (existingItemIndex != -1) {
            // If the item exists, update its quantity and price
            log('the item already in the cart');
            final existingItem = updatedItems[existingItemIndex];
            final updatedQuantity = existingItem.quantity + cartItem.quantity;
            final updatedPrice =
                existingItem.price + (cartItem.price * cartItem.quantity);
            final updatedItem = CartItemModel(
              id: existingItem.id,
              productId: existingItem.productId,
              variantId: existingItem.variantId,
              color: existingItem.color,
              size: existingItem.size,
              imageUrl: existingItem.imageUrl,
              quantity: updatedQuantity,
              price: updatedPrice,
            );
            updatedItems[existingItemIndex] = updatedItem;
            log('updated item in the cart and cart');
          } else {
            // If the item doesn't exist, add it to the list
            log('the item is not in the cart and added it to the cart');
            updatedItems.add(cartItem);
          }

          // Update total price and quantity
          final updatedTotalPrice = updatedItems.fold<double>(
            0.0,
            (s, item) => s + item.price,
          );
          final updatedTotalQuantity = updatedItems.fold<int>(
            0,
            (s, item) => s + item.quantity,
          );

          final updatedCart = CartModel(
            id: existingCart.id,
            totalPrice: updatedTotalPrice,
            totalQuantity: updatedTotalQuantity,
            items: updatedItems,
          );
          log('will updated cart in transaction');

          transaction.update(_cartDoc, updatedCart.toFireStore());
        }
      });
      log('Added Item successfull at data source');
    } on AuthException {
      rethrow;
    } catch (e) {
      log('Failure to Added Item at data source');
      throw ServerException(message: 'Failed to add item to cart');
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(_cartDoc);
        if (!snapshot.exists) {
          throw ServerException(message: 'Cart does not exist');
        }

        final existingCart = CartModel.fromFireStore(snapshot.data()!);
        final updatedItems = List<CartItemModel>.from(existingCart.items);

        // Remove the item from the list
        updatedItems.removeWhere((item) => item.id == itemId);

        // Update total price and quantity
        final updatedTotalPrice = updatedItems.fold<double>(
          0.0,
          (s, item) => s + item.price,
        );
        final updatedTotalQuantity = updatedItems.fold<int>(
          0,
          (s, item) => s + item.quantity,
        );

        final updatedCart = CartModel(
          id: existingCart.id,
          totalPrice: updatedTotalPrice,
          totalQuantity: updatedTotalQuantity,
          items: updatedItems,
        );

        transaction.update(_cartDoc, updatedCart.toFireStore());
      });
      log('Added Item successfull at data source');
    } catch (e) {
      log('Failure to Added Item at data source');
      throw ServerException(message: 'Failed to remove item from cart');
    }
  }

  @override
  Future<void> updateCartItem(String itemId, int quantity) async {
    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(_cartDoc);
        if (!snapshot.exists) {
          throw ServerException(message: 'Cart does not exist');
        }

        final existingCart = CartModel.fromFireStore(snapshot.data()!);
        final updatedItems = List<CartItemModel>.from(existingCart.items);

        // Find the item to update
        final existingItemIndex = updatedItems.indexWhere(
          (item) => item.id == itemId,
        );

        if (existingItemIndex == -1) {
          throw ServerException(message: 'Item not found in cart');
        }

        final existingItem = updatedItems[existingItemIndex];
        final updatedPrice =
            (existingItem.price / existingItem.quantity) * quantity;

        final updatedItem = CartItemModel(
          id: existingItem.id,
          productId: existingItem.productId,
          variantId: existingItem.variantId,
          color: existingItem.color,
          size: existingItem.size,
          imageUrl: existingItem.imageUrl,
          quantity: quantity,
          price: updatedPrice,
        );

        updatedItems[existingItemIndex] = updatedItem;

        // Update total price and quantity
        final updatedTotalPrice = updatedItems.fold<double>(
          0.0,
          (s, item) => s + item.price,
        );
        final updatedTotalQuantity = updatedItems.fold<int>(
          0,
          (s, item) => s + item.quantity,
        );

        final updatedCart = CartModel(
          id: existingCart.id,
          totalPrice: updatedTotalPrice,
          totalQuantity: updatedTotalQuantity,
          items: updatedItems,
        );

        transaction.update(_cartDoc, updatedCart.toFireStore());
      });
      log('Added Item successfull at data source');
    } catch (e) {
      throw ServerException(message: 'Failed to update cart item');
    }
  }

  @override
  Stream<CartModel> getCartItems() {
    try {
      final uid = _uid;

      return _cartDoc
          .snapshots()
          .map((snapshot) {
            if (!snapshot.exists) {
              return CartModel(
                id: uid,
                totalPrice: 0.0,
                totalQuantity: 0,
                items: [],
              );
            }
            return CartModel.fromFireStore(snapshot.data()!);
          })
          .handleError((error) {
            if (error is AuthException) {
              throw error;
            }
            throw ServerException(message: 'Failed to get cart items');
          });
    } on AuthException {
      return Stream.error(AuthException(message: 'User must be authenticated'));
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(_cartDoc);
        if (!snapshot.exists) {
          throw ServerException(message: 'Cart does not exist');
        }

        final existingCart = CartModel.fromFireStore(snapshot.data()!);
        final updatedCart = CartModel(
          id: existingCart.id,
          totalPrice: 0.0,
          totalQuantity: 0,
          items: [],
        );

        transaction.update(_cartDoc, updatedCart.toFireStore());
      });
    } catch (e) {
      throw ServerException(message: 'Failed to clear cart');
    }
  }
}
