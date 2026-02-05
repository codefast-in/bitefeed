import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
// import '../../../core/network/api_client.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../../../core/network/api_exception.dart';
// import '../../../core/config/app_config.dart';
import '../models/post_model.dart';

class PostRepository {
  final ApiClient _apiClient;

  PostRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get feed
  Future<List<PostModel>> getFeed({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.feed,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data['posts'] ?? response.data;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Get post details
  Future<PostModel> getPostDetails(String postId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.withId(ApiEndpoints.postDetails, postId),
      );

      return PostModel.fromJson(response.data['post'] ?? response.data);
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Get user posts
  Future<List<PostModel>> getUserPosts(String userId, {int page = 1}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.withId(ApiEndpoints.userPosts, userId),
        queryParameters: {'page': page},
      );

      final List<dynamic> data = response.data['posts'] ?? response.data;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Like post
  Future<bool> likePost(String postId) async {
    try {
      await _apiClient.post(ApiEndpoints.withId(ApiEndpoints.likePost, postId));
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Unlike post
  Future<bool> unlikePost(String postId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.withId(ApiEndpoints.unlikePost, postId),
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Save post
  Future<bool> savePost(String postId) async {
    try {
      await _apiClient.post(ApiEndpoints.withId(ApiEndpoints.savePost, postId));
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Unsave post
  Future<bool> unsavePost(String postId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.withId(ApiEndpoints.unsavePost, postId),
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Get saved posts
  Future<List<PostModel>> getSavedPosts({int page = 1}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.savedPosts,
        queryParameters: {'page': page},
      );

      final List<dynamic> data = response.data['posts'] ?? response.data;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Delete post
  Future<bool> deletePost(String postId) async {
    try {
      await _apiClient.delete(
        ApiEndpoints.withId(ApiEndpoints.deletePost, postId),
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }
}
