import 'package:flutter/foundation.dart';

abstract class LoggerService {
  void debug(String message);
  void info(String message);
  void warning(String message);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

class AppLogger implements LoggerService {
  @override
  void debug(String message) => debugPrint('[DEBUG] $message');

  @override
  void info(String message) => debugPrint('[INFO] $message');

  @override
  void warning(String message) => debugPrint('[WARN] $message');

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) {
      debugPrint(error.toString());
    }
  }
}
