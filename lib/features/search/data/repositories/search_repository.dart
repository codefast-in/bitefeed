import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../home/data/models/post_model.dart';


class SearchRepository {
  final ApiClient _apiClient;

  SearchRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Search all
  Future<Map<String, dynamic>> searchAll(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchAll,
        queryParameters: {'q': query},
      );

      final data = response.data;
      return {
        'users':
            (data['users'] as List?)
                ?.map((json) => UserModel.fromJson(json))
                .toList() ??
            [],
        'posts':
            (data['posts'] as List?)
                ?.map((json) => PostModel.fromJson(json))
                .toList() ??
            [],
        'restaurants': data['restaurants'] ?? [],
      };
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchUsers,
        queryParameters: {'q': query},
      );

      final List<dynamic> data = response.data['users'] ?? response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Search restaurants
  Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchRestaurants,
        queryParameters: {'q': query},
      );

      final List<dynamic> data = response.data['restaurants'] ?? response.data;
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }
}
