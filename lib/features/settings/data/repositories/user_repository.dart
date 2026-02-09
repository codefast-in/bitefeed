import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../auth/data/models/user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get user profile
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      final data = response.data;

      if (data['success'] == false) {
        throw UnknownException(data['message'] ?? 'Failed to load profile');
      }

      final userData =
          data['data']?['user'] ?? data['user'] ?? data['data'] ?? data;

      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }

  // Update profile
  Future<UserModel> updateProfile({
    String? fullName,
    String? username,
    String? email,
    List<String>? foodPreferences,
    String? profileImage,
    bool? contactsSynced,
    bool? notificationsEnabled,
    bool? locationEnabled,
    List<String>? customFoodPreferences,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.updateProfile,
        data: {
          if (fullName != null && fullName.isNotEmpty) 'fullName': fullName,
          if (username != null && username.isNotEmpty) 'username': username,
          if (email != null && email.isNotEmpty) 'email': email,
          if (foodPreferences != null) 'foodPreferences': foodPreferences,
          if (profileImage != null) 'profileImage': profileImage,
          if (contactsSynced != null) 'contactsSynced': contactsSynced,
          if (notificationsEnabled != null)
            'notificationsEnabled': notificationsEnabled,
          if (locationEnabled != null) 'locationEnabled': locationEnabled,
          if (customFoodPreferences != null)
            'customFoodPreferences': customFoodPreferences,
        },
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(data['message'] ?? 'Failed to update profile');
      }

      final userData =
          data['data']?['user'] ?? data['user'] ?? data['data'] ?? data;

      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }

  // Upload images (can be used for profile image)
  Future<List<String>> uploadImages(List<XFile> images) async {
    try {
      final formData = FormData();

      for (var image in images) {
        final bytes = await image.readAsBytes();
        formData.files.add(
          MapEntry(
            'images',
            MultipartFile.fromBytes(bytes, filename: image.name),
          ),
        );
      }

      final response = await _apiClient.post(
        ApiEndpoints.uploadImages,
        data: formData,
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(data['message'] ?? 'Image upload failed');
      }

      // FIXED: Check for 'images' key nested inside 'data'
      final List<dynamic> urls =
          data['data']?['images'] ??
          data['data']?['imageUrls'] ??
          data['imageUrls'] ??
          data['urls'] ??
          [];
      return urls.cast<String>();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Image upload failed');
    }
  }

  // Follow/Unfollow user
  Future<bool> toggleFollow(String userId) async {
    try {
      await _apiClient.post(ApiEndpoints.followUser, data: {'userId': userId});
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Get chat threads
  Future<List<Map<String, dynamic>>> getChatThreads(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.chatThreads,
        queryParameters: {'userId': userId},
      );

      // FIXED: Check for nested data structure
      final List<dynamic> data =
          response.data['data']?['threads'] ??
          response.data['threads'] ??
          response.data ??
          [];
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }
}
