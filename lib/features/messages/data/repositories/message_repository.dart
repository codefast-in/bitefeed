import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../models/message_model.dart';

class MessageRepository {
  final ApiClient _apiClient;

  MessageRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // Get conversations
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.conversations);

      final List<dynamic> data =
          response.data['conversations'] ?? response.data;
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Get messages
  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.withId(ApiEndpoints.messages, conversationId),
        queryParameters: {'page': page},
      );

      final List<dynamic> data = response.data['messages'] ?? response.data;
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Send message
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendMessage,
        data: {
          'conversation_id': conversationId,
          'content': content,
          'type': type.toString().split('.').last,
          if (imageUrl != null) 'image_url': imageUrl,
          if (metadata != null) 'metadata': metadata,
        },
      );

      return MessageModel.fromJson(response.data['message'] ?? response.data);
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Create conversation
  Future<ConversationModel> createConversation(String userId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createConversation,
        data: {'user_id': userId},
      );

      return ConversationModel.fromJson(
        response.data['conversation'] ?? response.data,
      );
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Create group chat
  Future<ConversationModel> createGroupChat({
    required String name,
    required List<String> userIds,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createGroupChat,
        data: {'name': name, 'user_ids': userIds},
      );

      return ConversationModel.fromJson(
        response.data['conversation'] ?? response.data,
      );
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Add members to group
  Future<bool> addMembersToGroup({
    required String groupId,
    required List<String> userIds,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.addGroupMembers,
        data: {'group_id': groupId, 'user_ids': userIds},
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }

  // Leave group
  Future<bool> leaveGroup(String groupId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.withId(ApiEndpoints.leaveGroup, groupId),
      );
      return true;
    } on DioException catch (e) {
      throw e.error as AppException;
    }
  }
}
