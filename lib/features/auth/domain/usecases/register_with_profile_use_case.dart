import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:setra/core/errors/errors.dart';
import 'package:setra/features/auth/domain/entities/user_entity.dart';
import 'package:setra/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/domain/use_cases/create_profile_use_case.dart';

class RegisterWithProfileUseCase {
  final RegisterUseCase _registerUseCase;
  final CreateProfileUseCase _createProfileUseCase;

  RegisterWithProfileUseCase({
    required RegisterUseCase registerUseCase,
    required CreateProfileUseCase createProfileUseCase,
  }) : _registerUseCase = registerUseCase,
       _createProfileUseCase = createProfileUseCase;

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final authResult = await _registerUseCase(
      name: name,
      email: email,
      password: password,
    );

    UserEntity? user;
    Failure? authFailure;

    authResult.fold(
      (failure) => authFailure = failure,
      (result) => user = result,
    );

    if (authFailure != null) {
      return Left(authFailure!);
    }

    final profile = ProfileEntity(
      id: user!.id,
      name: name.trim(),
      email: user!.email,
      createdAt: DateTime.now(),
    );

    final profileResult = await _createProfileUseCase(profile);
    log(
      '------------------------- ${profileResult.isLeft()}-------------------',
    );

    Failure? profileFailure;
    profileResult.fold((failure) => profileFailure = failure, (_) {});

    if (profileFailure != null) {
      return Left(profileFailure!);
    }

    return Right(user!);
  }
}
