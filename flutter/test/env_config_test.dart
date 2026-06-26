import 'package:flutter_test/flutter_test.dart';
import 'package:apps_alternator/core/config/env_config.dart';

void main() {
  group('Environment Configuration Unit Tests', () {
    test('Development Environment Setup', () {
      EnvConfig.initialize(Environment.development);
      expect(EnvConfig.environment, Environment.development);
      expect(EnvConfig.isDevelopment, isTrue);
      expect(EnvConfig.isProduction, isFalse);
      expect(EnvConfig.apiKey, 'DEV_GEMINI_API_KEY');
      expect(EnvConfig.baseUrl, 'https://api-dev.appsalternator.com');
    });

    test('Staging Environment Setup', () {
      EnvConfig.initialize(Environment.staging);
      expect(EnvConfig.environment, Environment.staging);
      expect(EnvConfig.isDevelopment, isFalse);
      expect(EnvConfig.isProduction, isFalse);
      expect(EnvConfig.apiKey, 'STG_GEMINI_API_KEY');
      expect(EnvConfig.baseUrl, 'https://api-stage.appsalternator.com');
    });

    test('Production Environment Setup', () {
      EnvConfig.initialize(Environment.production);
      expect(EnvConfig.environment, Environment.production);
      expect(EnvConfig.isProduction, isTrue);
      expect(EnvConfig.isDevelopment, isFalse);
      expect(EnvConfig.baseUrl, 'https://api.appsalternator.com');
    });
  });
}
