class AppConfig {
  // Environment
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // API Configuration
  static const String apiBaseUrl = 'http://83.136.219.131:8030/api/v1';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // Image Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];

  // Feature Flags
  static const bool enableLogging = true;
  static const bool enableCaching = true;

  // App Info
  static const String appName = 'BiteFeed';
  static const String appVersion = '1.0.0';

  static bool get isDevelopment => environment == 'dev';
  static bool get isProduction => environment == 'prod';
  static bool get isStaging => environment == 'staging';
}
