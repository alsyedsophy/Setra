import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/error_mapper.dart';
import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/orders/data/data_sources/order_remote_data_source.dart';
import 'package:setra/features/orders/data/models/order_model.dart';
import 'package:setra/features/orders/domain/entities/order_entity.dart';
import 'package:setra/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _handleCall<T>(Future<T> Function() action) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      return Right(await action());
    } on Exceptions catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) {
    return _handleCall(
      () => remoteDataSource.createOrder(OrderModel.fromEntity(order)),
    );
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) {
    return _handleCall(() => remoteDataSource.getOrderById(orderId));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders() {
    return _handleCall(() => remoteDataSource.getUserOrders());
  }

  @override
  Stream<Either<Failure, OrderEntity>> watchOrder(String orderId) async* {
    try {
      if (!await networkInfo.isConnected) {
        yield Left(NetworkFailure());
        return;
      }

      await for (final order in remoteDataSource.watchOrder(orderId)) {
        yield Right(order);
      }
    } on Exceptions catch (e) {
      yield Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      yield Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<OrderEntity>>> watchUserOrders() async* {
    try {
      if (!await networkInfo.isConnected) {
        yield Left(NetworkFailure());
        return;
      }

      await for (final orders in remoteDataSource.watchUserOrders()) {
        yield Right(orders);
      }
    } on Exceptions catch (e) {
      yield Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      yield Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) {
    return _handleCall(() async {
      await remoteDataSource.cancelOrder(orderId);
    });
  }
}
