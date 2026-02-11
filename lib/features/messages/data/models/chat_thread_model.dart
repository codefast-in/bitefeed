import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

class ThreadMessageModel extends Equatable {
  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;
  final bool isRead;

  const ThreadMessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
    this.isRead = false,
  });

  factory ThreadMessageModel.fromJson(Map<String, dynamic> json) {
    return ThreadMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      text: json['text'] ?? json['message'] ?? '',
      senderId:
          json['senderId'] ??
          json['sender']?['_id'] ??
          json['sender']?['id'] ??
          '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, text, senderId, createdAt, isRead];
}

class ChatThreadModel extends Equatable {
  final String type;
  final List<ThreadMessageModel> messages;

  const ChatThreadModel({required this.type, required this.messages});

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      type: json['type'] ?? 'dm',
      messages: (json['messages'] as List? ?? [])
          .map((m) => ThreadMessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [type, messages];
}
