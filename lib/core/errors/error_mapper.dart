import 'package:setra/core/errors/exceptions.dart';
import 'package:setra/core/errors/failures.dart';

class ErrorMapper {
  ErrorMapper._();

  static Failure mapExceptionToFailure(Exceptions e) {
    return switch (e) {
      AuthException e => AuthFailure(e.message),
      NetworkException e => NetworkFailure(e.message),
      ValidationException e => ValidationFailure(e.message),
      ServerException e => ServerFailure(e.message),
      CacheException e => CacheFailure(e.message),
      _ => UnknownFailure(e.message),
    };
  }
}
