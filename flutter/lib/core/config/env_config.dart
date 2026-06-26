enum Environment { development, staging, production }

/// Centralized Environment Configuration class
class EnvConfig {
  static late Environment _environment;
  static late String apiKey;
  static late String baseUrl;

  static void initialize(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.development:
        apiKey = 'DEV_GEMINI_API_KEY';
        baseUrl = 'https://api-dev.appsalternator.com';
        break;
      case Environment.staging:
        apiKey = 'STG_GEMINI_API_KEY';
        baseUrl = 'https://api-stage.appsalternator.com';
        break;
      case Environment.production:
        apiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
        baseUrl = 'https://api.appsalternator.com';
        break;
    }
  }

  static Environment get environment => _environment;
  static bool get isProduction => _environment == Environment.production;
  static bool get isDevelopment => _environment == Environment.development;
}
