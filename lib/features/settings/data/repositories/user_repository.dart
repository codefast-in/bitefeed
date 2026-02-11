import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import 'package:bitefeed/features/auth/data/models/user_model.dart';
import 'package:bitefeed/features/settings/data/models/blocked_user_model.dart';
import 'package:bitefeed/features/settings/data/models/other_user_profile_model.dart';
import 'package:bitefeed/features/messages/data/models/chat_thread_model.dart';
import 'package:bitefeed/core/models/pagination_model.dart';

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
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }

  // Get other user profile with bites & pagination
  Future<OtherUserProfileModel> getOtherUserProfile(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.otherUserProfile,
        queryParameters: {'userId': userId, 'page': page, 'limit': limit},
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(
          data['message'] ?? 'Failed to load user profile',
        );
      }

      return OtherUserProfileModel.fromJson(data['data'] ?? data);
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }

  // Toggle block user
  Future<bool> toggleBlockUser(String targetUserId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.toggleBlockUser,
        data: {'targetUserId': targetUserId},
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(data['message'] ?? 'Failed to toggle block');
      }

      return true;
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }

  // Get blocked users
  Future<Map<String, dynamic>> getBlockedUsers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getBlockedUsers,
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(
          data['message'] ?? 'Failed to load blocked users',
        );
      }

      final List<dynamic> results = data['data']?['results'] ?? [];
      final users = results.map((u) => BlockedUserModel.fromJson(u)).toList();
      final pagination = PaginationModel.fromJson(
        data['data']?['pagination'] ?? {},
      );

      return {'users': users, 'pagination': pagination};
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }

  // Get chat threads (DM structure)
  Future<ChatThreadModel> getChatThreads(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.chatThreads,
        queryParameters: {'userId': userId},
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(
          data['message'] ?? 'Failed to load chat threads',
        );
      }

      return ChatThreadModel.fromJson(data['data'] ?? data);
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }
}
