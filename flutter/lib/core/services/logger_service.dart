import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Production-ready LoggerService
/// Uses 'logger' package to manage levels (debug, info, warning, error)
/// Prepared for remote logging or local file logging in production.
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() => _instance;

  late final Logger _logger;

  LoggerService._internal() {
    _logger = Logger(
      filter: ProductionFilter(), // Ensures logs behave correctly in production
      printer: kDebugMode
          ? PrettyPrinter(
              methodCount: 2,
              errorMethodCount: 8,
              lineLength: 120,
              colors: true,
              printEmojis: true,
              printTime: true,
            )
          : SimplePrinter(colors: false),
      level: kDebugMode ? Level.debug : Level.warning, // Log warnings and errors only in production
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message) {
    _logger.i(message);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
