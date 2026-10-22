import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/cart/data/data_sources/remote_cart_data_source.dart';
import 'package:setra/features/cart/data/models/cart_model.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final RemoteCartDataSource _remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl(this._remoteDataSource, {required this.networkInfo});

  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final cartItemModel = CartItemModel.fromEntity(cartItem);
      log('convert item to model');
      await _remoteDataSource.addToCart(cartItemModel);
      log('Added Item successfull at repository');
      return const Right(null);
    } on AuthException {
      return Left(AuthFailure());
    } catch (e) {
      log('Failure to Added Item successfull at repository');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String itemId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.removeFromCart(itemId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(
    String itemId,
    int quantity,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.updateCartItem(itemId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<CartEntity> getCartItems() async* {
    if (!await networkInfo.isConnected) {
      yield* Stream.error(NetworkFailure());
      return;
    }

    try {
      yield* _remoteDataSource.getCartItems().handleError((error) {
        if (error is AuthException) {
          throw AuthFailure(error.message);
        }
        throw ServerFailure(error.toString());
      });
    } on AuthException catch (e) {
      yield* Stream.error(AuthFailure(e.message));
    } catch (e) {
      yield* Stream.error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replaceCart(CartEntity cart) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final model = CartModel.fromEntity(cart);
      await _remoteDataSource.replaceCart(model);
      return const Right(null);
    } on AuthException {
      return Left(AuthFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
