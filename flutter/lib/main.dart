import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/services/logger_service.dart';
import 'core/services/error_handler.dart';
import 'core/services/di_service.dart';
import 'core/config/env_config.dart';

void main() {
  // Wrap the entire app execution in a runZonedGuarded block to catch all asynchronous errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Initialize Logger Service
    final logger = LoggerService();
    logger.info('Initializing Apps Alternator Foundation...');

    // 2. Setup Environment Configuration (Default to Production, toggleable in Dev)
    EnvConfig.initialize(Environment.production);
    logger.info('Environment initialized: ${EnvConfig.environment.name}');

    // 3. Setup Dependency Injection (GetIt)
    await DIService.initialize();
    logger.info('Dependency Injection Service successfully initialized.');

    // 4. Initialize Global Flutter Error Catching
    FlutterError.onError = (FlutterErrorDetails details) {
      ErrorHandler.handleFlutterError(details);
    };

    // Run the App with Riverpod State Provider scope
    runApp(
      const ProviderScope(
        child: AppsAlternatorApp(),
      ),
    );
  }, (error, stackTrace) {
    // Catch-all for async zones errors
    ErrorHandler.handleAsyncError(error, stackTrace);
  });
}

class AppsAlternatorApp extends ConsumerWidget {
  const AppsAlternatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvidor);

    return MaterialApp.router(
      title: 'Apps Alternator',
      debugShowCheckedModeBanner: false,

      // Light and Dark Minimal Themes Configured
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Auto respect system preference

      // go_router implementation for declarative routing
      routerConfig: router,
    );
  }
}
