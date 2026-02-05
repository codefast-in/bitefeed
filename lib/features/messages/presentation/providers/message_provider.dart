import 'package:flutter/material.dart';
import '../../data/repositories/message_repository.dart';
import '../../data/models/message_model.dart';
import '../../../../core/network/api_exception.dart';

enum MessagesState { initial, loading, loaded, sending, error }

class MessageProvider extends ChangeNotifier {
  final MessageRepository _messageRepository;

  MessageProvider({MessageRepository? messageRepository})
    : _messageRepository = messageRepository ?? MessageRepository();

  // State
  MessagesState _state = MessagesState.initial;
  List<ConversationModel> _conversations = [];
  Map<String, List<MessageModel>> _messagesByConversation = {};
  String? _errorMessage;
  String? _currentConversationId;

  // Getters
  MessagesState get state => _state;
  List<ConversationModel> get conversations => _conversations;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == MessagesState.loading;
  bool get isSending => _state == MessagesState.sending;

  List<MessageModel> getMessages(String conversationId) {
    return _messagesByConversation[conversationId] ?? [];
  }

  // Load conversations
  Future<void> loadConversations() async {
    _state = MessagesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _conversations = await _messageRepository.getConversations();
      _state = MessagesState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = MessagesState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MessagesState.error;
      notifyListeners();
    }
  }

  // Load messages for a conversation
  Future<void> loadMessages(String conversationId) async {
    _currentConversationId = conversationId;
    _state = MessagesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final messages = await _messageRepository.getMessages(conversationId);
      _messagesByConversation[conversationId] = messages;
      _state = MessagesState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = MessagesState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MessagesState.error;
      notifyListeners();
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) async {
    _state = MessagesState.sending;
    _errorMessage = null;
    notifyListeners();

    try {
      final message = await _messageRepository.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        imageUrl: imageUrl,
        metadata: metadata,
      );

      // Add message to local list
      if (_messagesByConversation.containsKey(conversationId)) {
        _messagesByConversation[conversationId]!.add(message);
      } else {
        _messagesByConversation[conversationId] = [message];
      }

      // Update conversation's last message
      final convIndex = _conversations.indexWhere(
        (c) => c.id == conversationId,
      );
      if (convIndex != -1) {
        // Move conversation to top and update last message
        final updatedConv = _conversations.removeAt(convIndex);
        _conversations.insert(0, updatedConv);
      }

      _state = MessagesState.loaded;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = MessagesState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MessagesState.error;
      notifyListeners();
      return false;
    }
  }

  // Create conversation
  Future<ConversationModel?> createConversation(String userId) async {
    _state = MessagesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final conversation = await _messageRepository.createConversation(userId);
      _conversations.insert(0, conversation);
      _state = MessagesState.loaded;
      notifyListeners();
      return conversation;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = MessagesState.error;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MessagesState.error;
      notifyListeners();
      return null;
    }
  }

  // Create group chat
  Future<ConversationModel?> createGroupChat({
    required String name,
    required List<String> userIds,
  }) async {
    _state = MessagesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final conversation = await _messageRepository.createGroupChat(
        name: name,
        userIds: userIds,
      );
      _conversations.insert(0, conversation);
      _state = MessagesState.loaded;
      notifyListeners();
      return conversation;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = MessagesState.error;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MessagesState.error;
      notifyListeners();
      return null;
    }
  }

  // Add members to group
  Future<bool> addMembersToGroup({
    required String groupId,
    required List<String> userIds,
  }) async {
    try {
      await _messageRepository.addMembersToGroup(
        groupId: groupId,
        userIds: userIds,
      );
      // Reload conversations to get updated group info
      await loadConversations();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Leave group
  Future<bool> leaveGroup(String groupId) async {
    try {
      await _messageRepository.leaveGroup(groupId);
      _conversations.removeWhere((c) => c.id == groupId);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
