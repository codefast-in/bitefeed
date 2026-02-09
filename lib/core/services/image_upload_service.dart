import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_exception.dart';

class ImageUploadService {
  final ApiClient _apiClient;

  ImageUploadService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Upload multiple images and return the uploaded image URLs
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    try {
      debugPrint(
        '📤 ImageUploadService: Uploading ${imageFiles.length} images...',
      );

      // Create FormData with all images
      final formData = FormData();

      for (var imageFile in imageFiles) {
        final fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
          ),
        );
      }

      debugPrint(
        '📤 ImageUploadService: Posting to ${ApiEndpoints.uploadImages}...',
      );

      final response = await _apiClient.post(
        ApiEndpoints.uploadImages,
        data: formData,
      );

      debugPrint('✅ ImageUploadService: Upload response: ${response.data}');

      // Extract image URLs from response
      // Response format: {"data": {"images": ["temp/file1.png", "temp/file2.jpg"]}, "count": 2, ...}
      final data = response.data['data'] ?? response.data;
      final List<dynamic> images = data['images'] ?? [];

      final imageUrls = images.map((img) => img.toString()).toList();

      debugPrint(
        '✅ ImageUploadService: Uploaded ${imageUrls.length} images successfully',
      );
      debugPrint('📷 Image URLs: $imageUrls');

      return imageUrls;
    } on DioException catch (e) {
      debugPrint('❌ ImageUploadService: Upload failed - ${e.message}');
      debugPrint('❌ Error response: ${e.response?.data}');
      throw e.error as AppException;
    } catch (e) {
      debugPrint('❌ ImageUploadService: Unexpected error - $e');
      rethrow;
    }
  }

  /// Upload a single image and return the uploaded image URL
  Future<String> uploadImage(File imageFile) async {
    final urls = await uploadImages([imageFile]);
    return urls.first;
  }
}
