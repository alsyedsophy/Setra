abstract class Exceptions {
  final String message;

  Exceptions({required this.message});
}

class NetworkException extends Exceptions {
  NetworkException({required super.message});
}

class ServerException extends Exceptions {
  ServerException({required super.message});
}

class CacheException extends Exceptions {
  CacheException({required super.message});
}

class AuthException extends Exceptions {
  AuthException({required super.message});
}

class ValidationException extends Exceptions {
  ValidationException({required super.message});
}

class UnKnowWxception extends Exceptions {
  UnKnowWxception({required super.message});
}
