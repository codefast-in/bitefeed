import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('🔐 AuthRepository: Calling signup API for $email');
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      debugPrint('✅ AuthRepository: Signup API successful');
      final authResponse = AuthResponseModel.fromJson(response.data['data']);

      // Save tokens
      debugPrint('💾 AuthRepository: Saving tokens after signup...');
      await _storage.setSecureString(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );
      await _storage.setSecureString(
        StorageKeys.refreshToken,
        authResponse.refreshToken,
      );

      // Save user data
      debugPrint(
        '💾 AuthRepository: Saving user data for ${authResponse.user.fullName}',
      );
      await _storage.setJson(StorageKeys.userData, authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      debugPrint('❌ AuthRepository: Signup failed - ${e.message}');
      throw (e.error is AppException)
          ? e.error as AppException
          : UnknownException(e.message ?? 'Signup failed');
    }
  }

  // Login
  // Login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 AuthRepository: Calling login API for $email');
      // FIXED: Call _apiClient.post instead of _authRepository.login
      final response = await _apiClient.post(
        ApiEndpoints.login, // Make sure this endpoint exists in ApiEndpoints
        data: {'email': email, 'password': password},
      );

      debugPrint('✅ AuthRepository: Login API successful');
      final authResponse = AuthResponseModel.fromJson(response.data['data']);

      // Save tokens
      debugPrint('💾 AuthRepository: Saving access token...');
      await _storage.setSecureString(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );
      debugPrint('💾 AuthRepository: Saving refresh token...');
      await _storage.setSecureString(
        StorageKeys.refreshToken,
        authResponse.refreshToken,
      );

      // Save user data
      debugPrint(
        '💾 AuthRepository: Saving user data for ${authResponse.user.fullName}',
      );
      await _storage.setJson(StorageKeys.userData, authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      debugPrint('❌ AuthRepository: Login failed - ${e.message}');
      throw (e.error is AppException)
          ? e.error as AppException
          : UnknownException(e.message ?? 'Login failed');
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
      debugPrint('🗑️ AuthRepository: Clearing tokens and user data...');
      // Clear local storage
      await _storage.deleteSecure(StorageKeys.accessToken);
      await _storage.deleteSecure(StorageKeys.refreshToken);
      await _storage.delete(StorageKeys.userData);
      debugPrint('✅ AuthRepository: Logout complete');
    } catch (e) {
      debugPrint('❌ AuthRepository: Error during logout - $e');
      // Even if there's an error, clear local data
      await _storage.deleteSecure(StorageKeys.accessToken);
      await _storage.deleteSecure(StorageKeys.refreshToken);
      await _storage.delete(StorageKeys.userData);
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    debugPrint('🔍 AuthRepository: Checking if user is logged in...');
    final token = await _storage.readSecure(StorageKeys.accessToken);
    final isLoggedIn = token != null && token.isNotEmpty;
    debugPrint('🔍 AuthRepository: Token exists = $isLoggedIn');
    return isLoggedIn;
  }

  // Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    debugPrint('👤 AuthRepository: Loading user from storage...');
    final userData = await _storage.readJson(StorageKeys.userData);
    if (userData != null) {
      final user = UserModel.fromJson(userData);
      debugPrint('👤 AuthRepository: User loaded - ${user.fullName}');
      return user;
    }
    debugPrint('❌ AuthRepository: No user data in storage');
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
