import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

enum MessageType { text, image, planVisit }

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final UserModel sender;
  final String content;
  final MessageType type;
  final String? imageUrl;
  final Map<String, dynamic>? metadata; // For plan visit data
  final bool isRead;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    this.type = MessageType.text,
    this.imageUrl,
    this.metadata,
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? json['_id'] ?? '',
      conversationId: json['conversation_id'] ?? json['conversationId'] ?? '',
      sender: UserModel.fromJson(json['sender'] ?? {}),
      content: json['content'] ?? '',
      type: _parseMessageType(json['type']),
      imageUrl: json['image_url'] ?? json['imageUrl'],
      metadata: json['metadata'],
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  static MessageType _parseMessageType(dynamic type) {
    if (type == null) return MessageType.text;
    if (type is MessageType) return type;

    switch (type.toString().toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'planvisit':
      case 'plan_visit':
        return MessageType.planVisit;
      default:
        return MessageType.text;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender': sender.toJson(),
      'content': content,
      'type': type.toString().split('.').last,
      'image_url': imageUrl,
      'metadata': metadata,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? conversationId,
    UserModel? sender,
    String? content,
    MessageType? type,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    conversationId,
    sender,
    content,
    type,
    imageUrl,
    metadata,
    isRead,
    createdAt,
  ];
}

class ConversationModel extends Equatable {
  final String id;
  final String? name; // For group chats
  final bool isGroup;
  final List<UserModel> participants;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  const ConversationModel({
    required this.id,
    this.name,
    this.isGroup = false,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.lastMessageAt,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'],
      isGroup: json['is_group'] ?? json['isGroup'] ?? false,
      participants: json['participants'] != null
          ? (json['participants'] as List)
                .map((p) => UserModel.fromJson(p))
                .toList()
          : [],
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? json['unreadCount'] ?? 0,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    isGroup,
    participants,
    lastMessage,
    unreadCount,
    lastMessageAt,
    createdAt,
  ];
}
