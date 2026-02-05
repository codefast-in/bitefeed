import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/storage/storage_keys.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storage;

  AuthRepository({ApiClient? apiClient, StorageService? storage})
    : _apiClient = apiClient ?? ApiClient(),
      _storage = storage ?? StorageService();

  // Register (Signup)
  Future<AuthResponseModel> signup({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Save tokens
      await _storage.saveSecure(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );
      await _storage.saveSecure(
        StorageKeys.refreshToken,
        authResponse.refreshToken,
      );
      await _storage.saveJson(StorageKeys.userData, authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Save tokens
      await _storage.saveSecure(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );
      await _storage.saveSecure(
        StorageKeys.refreshToken,
        authResponse.refreshToken,
      );
      await _storage.saveJson(StorageKeys.userData, authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Forgot Password
  Future<bool> forgotPassword({required String email}) async {
    try {
      await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Verify Code
  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyCode,
        data: {'email': email, 'code': code},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Reset Password
  Future<bool> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'resetToken': resetToken,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Clear local storage
      await _storage.deleteSecure(StorageKeys.accessToken);
      await _storage.deleteSecure(StorageKeys.refreshToken);
      await _storage.delete(StorageKeys.userData);
    } catch (e) {
      // Even if there's an error, clear local data
      await _storage.deleteSecure(StorageKeys.accessToken);
      await _storage.deleteSecure(StorageKeys.refreshToken);
      await _storage.delete(StorageKeys.userData);
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.readSecure(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  // Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    final userData = await _storage.readJson(StorageKeys.userData);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storage.readSecure(StorageKeys.accessToken);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.readSecure(StorageKeys.refreshToken);
  }
}

extension on Future<String?> {
  bool? get isNotEmpty => null;
}
