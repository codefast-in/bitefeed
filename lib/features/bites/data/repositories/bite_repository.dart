import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../models/bite_model.dart';

class BiteRepository {
  final ApiClient _apiClient;

  BiteRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get bite feed with pagination
  Future<Map<String, dynamic>> getBitesFeed({
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
    String? currentUserId,
    Map<String, dynamic>? filters,
  }) async {
    try {
      debugPrint(
        '🍔 BiteRepository: Fetching feed page $page (limit: $limit)...',
      );
      final response = await _apiClient.get(
        ApiEndpoints.biteFeed,
        queryParameters: {
          'page': page,
          'limit': limit,
          'sortBy': sortBy,
          ...?filters,
        },
      );

      final responseData = response.data;
      if (responseData['success'] == false) {
        throw UnknownException(
          responseData['message'] ?? 'Failed to fetch feed',
        );
      }

      final data = responseData['data'] ?? responseData;
      final List<dynamic> bitesData = data['bites'] ?? [];
      final bites = bitesData
          .map((json) => BiteModel.fromJson(json, currentUserId: currentUserId))
          .toList();

      final pagination = data['pagination'] ?? {};
      final currentPage = pagination['page'] ?? data['currentPage'] ?? page;
      final totalPages = pagination['pages'] ?? data['totalPages'] ?? 1;
      final totalBites =
          pagination['total'] ?? data['totalBites'] ?? bites.length;

      debugPrint(
        '✅ BiteRepository: Loaded ${bites.length} bites (page $currentPage/$totalPages, total: $totalBites)',
      );

      return {
        'bites': bites,
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalBites': totalBites,
      };
    } on DioException catch (e) {
      debugPrint('❌ BiteRepository: Get feed failed - ${e.message}');
      throw e.error as AppException;
    }
  }

  // Get bite feed (legacy - for backward compatibility)
  Future<List<BiteModel>> getBites({
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
    Map<String, dynamic>? filters,
  }) async {
    final response = await getBitesFeed(
      page: page,
      limit: limit,
      sortBy: sortBy,
      filters: filters,
    );
    return response['bites'];
  }

  // Get my bites
  Future<List<BiteModel>> getMyBites({
    int page = 1,
    int limit = 10,
    String sortBy = 'newest',
    String? currentUserId,
  }) async {
    try {
      debugPrint('📱 BiteRepository: Fetching my bites page $page...');
      final response = await _apiClient.get(
        ApiEndpoints.myBites,
        queryParameters: {'page': page, 'limit': limit, 'sortBy': sortBy},
      );

      final data = response.data;
      if (data['success'] == false) {
        throw UnknownException(data['message'] ?? 'Failed to fetch my bites');
      }

      debugPrint(
        '📱 BiteRepository: My bites response structure: ${data.keys}',
      );

      // Extract from nested structure: data.myBites.list
      final myBitesData = data['myBites'] ?? data['data']?['myBites'] ?? {};
      final List<dynamic> bitesArray = myBitesData['list'] ?? [];

      debugPrint('✅ BiteRepository: Found ${bitesArray.length} my bites');

      return bitesArray
          .map((json) => BiteModel.fromJson(json, currentUserId: currentUserId))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ BiteRepository: Get my bites failed - ${e.message}');
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
    String? currentUserId,
  }) async {
    try {
      final requestData = {
        if (editID != null) 'editID': editID,
        'restaurantName': restaurantName,
        'photos': photos,
        'rating': rating,
        if (caption != null) 'caption': caption,
        if (tags != null) 'tags': tags,
        if (restaurantLocation != null)
          'restaurantLocation': restaurantLocation,
        'status': status,
      };

      debugPrint(
        '📝 BiteRepository: ${editID != null ? "Updating" : "Creating"} bite with data: $requestData',
      );

      final response = await _apiClient.post(
        ApiEndpoints.createBite,
        data: requestData,
      );

      final responseData = response.data;
      if (responseData['success'] == false) {
        throw UnknownException(
          responseData['message'] ??
              'Failed to ${editID != null ? "update" : "create"} bite',
        );
      }

      debugPrint(
        '✅ BiteRepository: Bite ${editID != null ? "updated" : "created"} successfully',
      );
      debugPrint('📝 Response data: $responseData');

      final biteData =
          response.data['bite'] ??
          response.data['data']?['bite'] ??
          response.data['data'] ??
          response.data;
      return BiteModel.fromJson(biteData, currentUserId: currentUserId);
    } on DioException catch (e) {
      debugPrint('❌ BiteRepository: Create/update bite failed - ${e.message}');
      debugPrint('❌ Error response: ${e.response?.data}');
      throw e.error as AppException;
    }
  }

  // Delete bite
  Future<bool> deleteBite(String biteId) async {
    try {
      debugPrint('🗑️ BiteRepository: Deleting bite $biteId...');
      await _apiClient.post(
        ApiEndpoints.createBite,
        data: {'editID': biteId, 'del': true},
      );
      debugPrint('✅ BiteRepository: Bite deleted successfully');
      return true;
    } on DioException catch (e) {
      debugPrint('❌ BiteRepository: Delete bite failed - ${e.message}');
      throw e.error as AppException;
    }
  }

  // Like/Unlike bite
  Future<Map<String, dynamic>> toggleLike(String biteId) async {
    try {
      debugPrint('👍 BiteRepository: Toggling like for bite $biteId...');
      final response = await _apiClient.post(
        ApiEndpoints.likeBite,
        queryParameters: {'id': biteId},
      );

      final data = response.data;
      final result = {
        'message': data['message'] ?? 'Bite liked',
        'isLiked': data['isLiked'] ?? data['liked'] ?? true,
        'likesCount': data['likesCount'] ?? data['likes'] ?? 0,
      };

      debugPrint(
        '✅ BiteRepository: ${result['message']} (isLiked=${result['isLiked']})',
      );
      return result;
    } on DioException catch (e) {
      debugPrint('❌ BiteRepository: Toggle like failed - ${e.message}');
      throw e.error as AppException;
    }
  }

  // Bookmark/Unbookmark bite
  Future<Map<String, dynamic>> toggleBookmark(String biteId) async {
    try {
      debugPrint('🔖 BiteRepository: Toggling bookmark for bite $biteId...');
      final response = await _apiClient.post(
        ApiEndpoints.bookmarkBite,
        queryParameters: {'id': biteId},
      );

      final data = response.data;
      final result = {
        'message': data['message'] ?? 'Bite bookmarked',
        'isBookmarked': data['isBookmarked'] ?? data['bookmarked'] ?? true,
      };

      debugPrint(
        '✅ BiteRepository: ${result['message']} (isBookmarked=${result['isBookmarked']})',
      );
      return result;
    } on DioException catch (e) {
      debugPrint('❌ BiteRepository: Toggle bookmark failed - ${e.message}');
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
  Future<List<String>> uploadImages(List<XFile> imageFiles) async {
    try {
      final formData = FormData();

      for (var image in imageFiles) {
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

      final responseData = response.data;
      if (responseData['success'] == false) {
        throw UnknownException(
          responseData['message'] ?? 'Image upload failed',
        );
      }

      // Handle response structure: data: { images: [...] }
      final data = responseData['data'] ?? {};
      final List<dynamic> imageUrls =
          data['images'] ??
          responseData['imageUrls'] ??
          responseData['urls'] ??
          [];

      return imageUrls.cast<String>();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }
}
