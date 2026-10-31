import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      return Right(await action());
    } on FirebaseException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) {
    return _execute(
      () => remoteDataSource.createOrder(OrderModel.fromEntity(order)),
    );
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) {
    return _execute(() => remoteDataSource.getOrderById(orderId));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders() {
    return _execute(() => remoteDataSource.getUserOrders());
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
    } on FirebaseException {
      yield Left(ServerFailure());
    } catch (_) {
      yield Left(ServerFailure());
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
    } on FirebaseException {
      yield Left(ServerFailure());
    } catch (_) {
      yield Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) {
    return _execute(() async {
      await remoteDataSource.cancelOrder(orderId);
    });
  }
}
