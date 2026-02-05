import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/data/models/user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get user profile
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data['user'] ?? response.data);
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Update profile
  Future<UserModel> updateProfile({
    String? fullName,
    String? username,
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
          if (fullName != null) 'fullName': fullName,
          if (username != null) 'username': username,
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

      return UserModel.fromJson(response.data['user'] ?? response.data);
    } on DioException catch (e) {
      throw e.error as AppException;
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

      final List<dynamic> urls =
          response.data['imageUrls'] ?? response.data['urls'] ?? [];
      return urls.cast<String>();
    } on DioException catch (e) {
      throw e.error as AppException;
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

      final List<dynamic> data = response.data['threads'] ?? response.data;
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }
}
