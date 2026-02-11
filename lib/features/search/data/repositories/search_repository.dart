import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../models/search_response_model.dart';

class SearchRepository {
  final ApiClient _apiClient;

  SearchRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<SearchResponseModel> searchUserAndBites(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchUserAndBites,
        queryParameters: {'search': query, 'page': page, 'limit': limit},
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(data['message'] ?? 'Search failed');
      }

      return SearchResponseModel.fromJson(data['data'] ?? data);
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw UnknownException(e.message ?? 'Unknown network error');
    }
  }
}
