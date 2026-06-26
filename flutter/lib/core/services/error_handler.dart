import 'package:flutter/material.dart';
import 'logger_service.dart';

/// Centralized Global Error Handler
/// Safely captures uncaught exceptions, logs them with rich traces,
/// and presents helpful user-friendly fallbacks in case of render crashes.
class ErrorHandler {
  ErrorHandler._();

  static final _logger = LoggerService();

  /// Captures synchronous Flutter errors (e.g. Layout overflow, build exceptions)
  static void handleFlutterError(FlutterErrorDetails details) {
    _logger.error(
      'Caught Unhandled Flutter Error: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
  }

  /// Captures asynchronous errors (e.g., failed API calls, timer exceptions)
  static void handleAsyncError(Object error, StackTrace stackTrace) {
    _logger.error(
      'Caught Unhandled Asynchronous Zone Error: $error',
      error,
      stackTrace,
    );
  }

  /// Custom UI for UI-render crashes, replacing the default red screen of death
  static Widget getErrorWidget(BuildContext context, FlutterErrorDetails details) {
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Our engineering team has been notified. Please restart the app.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
