/// Base class for expected, business-level failures.
///
/// Failures represent conditions the application should handle (no network,
/// invalid credentials, validation errors). They are the only error type that
/// Cubits are allowed to catch, as opposed to unexpected [Exception]s.
abstract class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;
}

class NetworkFailure extends Failure {
  NetworkFailure([
    String message = 'No internet connection',
    String? code = 'network',
  ]) : super(message: message, code: code);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error', String? code = 'server'])
    : super(message: message, code: code);
}

class CacheFailure extends Failure {
  CacheFailure([String message = 'Cache error', String? code = 'cache'])
    : super(message: message, code: code);
}

class AuthFailure extends Failure {
  AuthFailure([String message = 'Authentication failed', String? code = 'auth'])
    : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  ValidationFailure([
    String message = 'validation_failed',
    String? code = 'validation',
  ]) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  UnknownFailure([
    String message = 'Unexpected error',
    String? code = 'unknown',
  ]) : super(message: message, code: code);
}
