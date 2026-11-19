import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/error_mapper.dart';
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
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem) =>
      _handleCall(() async {
        await _remoteDataSource.addToCart(CartItemModel.fromEntity(cartItem));
      });
  @override
  Future<Either<Failure, void>> removeFromCart(String itemId) =>
      _handleCall(() async {
        await _remoteDataSource.removeFromCart(itemId);
      });

  @override
  Future<Either<Failure, void>> updateCartItem(String itemId, int quantity) =>
      _handleCall(() async {
        await _remoteDataSource.updateCartItem(itemId, quantity);
      });

  @override
  Future<Either<Failure, void>> clearCart() => _handleCall(() async {
    await _remoteDataSource.clearCart();
  });

  @override
  Future<Either<Failure, void>> replaceCart(CartEntity cart) =>
      _handleCall(() async {
        await _remoteDataSource.replaceCart(CartModel.fromEntity(cart));
      });

  @override
  Stream<CartEntity> getCartItems() async* {
    if (!await networkInfo.isConnected) {
      yield* Stream.error(NetworkFailure());
      return;
    }

    try {
      yield* _remoteDataSource.getCartItems().handleError((error) {
        if (error is Exceptions) {
          throw ErrorMapper.mapExceptionToFailure(error);
        }
        throw UnknownFailure(error.toString());
      });
    } on Exceptions catch (e) {
      yield* Stream.error(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      yield* Stream.error(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> _handleCall<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      return Right(await call());
    } on Exceptions catch (e, st) {
      log('Cart call failed', error: e, stackTrace: st);
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e, st) {
      log('Unexpected cart error', error: e, stackTrace: st);
      return Left(UnknownFailure());
    }
  }
}
