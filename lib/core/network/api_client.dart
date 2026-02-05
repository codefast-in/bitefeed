import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../storage/storage_service.dart';
import '../storage/storage_keys.dart';
import 'api_exception.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;
  final _logger = Logger();
  final _storage = StorageService();

  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  // Authentication Interceptor
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to requests
        final token = await _storage.getSecureString(StorageKeys.accessToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token expiration
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the request
            final options = error.requestOptions;
            final token = await _storage.getSecureString(
              StorageKeys.accessToken,
            );
            options.headers['Authorization'] = 'Bearer $token';

            try {
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    );
  }

  // Logging Interceptor
  InterceptorsWrapper _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (AppConfig.enableLogging) {
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (AppConfig.enableLogging) {
          _logger.i(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          _logger.i('Data: ${response.data}');
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        if (AppConfig.enableLogging) {
          _logger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          _logger.e('Message: ${error.message}');
          _logger.e('Data: ${error.response?.data}');
        }
        return handler.next(error);
      },
    );
  }

  // Error Interceptor
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final exception = _handleError(error);
        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: exception,
            response: error.response,
            type: error.type,
          ),
        );
      },
    );
  }

  // Handle different types of errors
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timeout. Please try again.');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const UnknownException('Request cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');

      default:
        return const UnknownException('An unexpected error occurred');
    }
  }

  // Handle HTTP response errors
  AppException _handleResponseError(Response? response) {
    if (response == null) {
      return const UnknownException('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final message = data is Map ? (data['message'] ?? data['error']) : null;

    switch (statusCode) {
      case 400:
        return BadRequestException(message ?? 'Invalid request');

      case 401:
        return UnauthorizedException(message ?? 'Unauthorized access');

      case 403:
        return ForbiddenException(message ?? 'Access forbidden');

      case 404:
        return NotFoundException(message ?? 'Resource not found');

      case 409:
        return ConflictException(message ?? 'Resource conflict');

      case 422:
        final errors = data is Map ? data['errors'] : null;
        return ValidationException(message ?? 'Validation failed', errors);

      case 500:
      case 502:
      case 503:
        return ServerException(
          message ?? 'Server error. Please try again later.',
          statusCode,
        );

      default:
        return ServerException(message ?? 'An error occurred', statusCode);
    }
  }

  // Refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getSecureString(
        StorageKeys.refreshToken,
      );
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await _storage.setSecureString(StorageKeys.accessToken, newAccessToken);
        if (newRefreshToken != null) {
          await _storage.setSecureString(
            StorageKeys.refreshToken,
            newRefreshToken,
          );
        }

        return true;
      }
      return false;
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      return false;
    }
  }

  // Helper methods for common HTTP operations
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
