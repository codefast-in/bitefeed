import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

// Network Exceptions
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
    : super(message, 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException(String message, [this.statusCode, String? code])
    : super(message, code);

  @override
  List<Object?> get props => [message, code, statusCode];
}

// Authentication Exceptions
class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Unauthorized access'])
    : super(message, 'UNAUTHORIZED');
}

class TokenExpiredException extends AppException {
  const TokenExpiredException([String message = 'Session expired'])
    : super(message, 'TOKEN_EXPIRED');
}

// Validation Exceptions
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(String message, [this.errors])
    : super(message, 'VALIDATION_ERROR');

  @override
  List<Object?> get props => [message, code, errors];
}

// Data Exceptions
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found'])
    : super(message, 'NOT_FOUND');
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache error occurred'])
    : super(message, 'CACHE_ERROR');
}

// Generic Exceptions
class UnknownException extends AppException {
  const UnknownException([String message = 'An unknown error occurred'])
    : super(message, 'UNKNOWN_ERROR');
}

class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timeout'])
    : super(message, 'TIMEOUT');
}

class BadRequestException extends AppException {
  const BadRequestException([String message = 'Bad request'])
    : super(message, 'BAD_REQUEST');
}

class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'Access forbidden'])
    : super(message, 'FORBIDDEN');
}

class ConflictException extends AppException {
  const ConflictException([String message = 'Resource conflict'])
    : super(message, 'CONFLICT');
}
