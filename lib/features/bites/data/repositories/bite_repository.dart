import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../models/bite_model.dart';
import '../models/bite_model.dart';

class BiteRepository {
  final ApiClient _apiClient;

  BiteRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get bite feed
  Future<List<BiteModel>> getBites({
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.biteFeed,
        queryParameters: {
          'page': page,
          'limit': limit,
          'sortBy': sortBy,
          ...?filters,
        },
      );

      final List<dynamic> data = response.data['bites'] ?? response.data;
      return data.map((json) => BiteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Get my bites
  Future<List<BiteModel>> getMyBites({
    int page = 1,
    int limit = 10,
    String sortBy = 'newest',
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.myBites,
        queryParameters: {'page': page, 'limit': limit, 'sortBy': sortBy},
      );

      final List<dynamic> data = response.data['bites'] ?? response.data;
      return data.map((json) => BiteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Create bite
  Future<BiteModel> createBite({
    String? editID,
    required String restaurantName,
    required List<String> photos,
    required double rating,
    String? caption,
    List<String>? tags,
    Map<String, dynamic>? restaurantLocation,
    String status = 'published',
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createBite,
        data: {
          if (editID != null) 'editID': editID,
          'restaurantName': restaurantName,
          'photos': photos,
          'rating': rating,
          if (caption != null) 'caption': caption,
          if (tags != null) 'tags': tags,
          if (restaurantLocation != null)
            'restaurantLocation': restaurantLocation,
          'status': status,
        },
      );

      return BiteModel.fromJson(response.data['bite'] ?? response.data);
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Delete bite
  Future<bool> deleteBite(String biteId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.createBite,
        data: {'editID': biteId, 'del': true},
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Like/Unlike bite
  Future<bool> toggleLike(String biteId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.likeBite,
        queryParameters: {'id': biteId},
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Bookmark/Unbookmark bite
  Future<bool> toggleBookmark(String biteId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.bookmarkBite,
        queryParameters: {'id': biteId},
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Add/Edit comment
  Future<Map<String, dynamic>> addComment({
    required String biteId,
    String? editID,
    required String text,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.commentBite,
        queryParameters: {'id': biteId},
        data: {if (editID != null) 'editID': editID, 'text': text},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Upload images
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
}
