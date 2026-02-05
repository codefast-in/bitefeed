import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

enum NotificationType { like, comment, follow, message, mention, system }

class NotificationModel extends Equatable {
  final String id;
  final NotificationType type;
  final UserModel? fromUser; // null for system notifications
  final String title;
  final String message;
  final String? imageUrl;
  final String? actionUrl; // Deep link or route
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    this.fromUser,
    required this.title,
    required this.message,
    this.imageUrl,
    this.actionUrl,
    this.metadata,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? json['_id'] ?? '',
      type: _parseNotificationType(json['type']),
      fromUser: json['from_user'] != null
          ? UserModel.fromJson(json['from_user'])
          : null,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'],
      actionUrl: json['action_url'] ?? json['actionUrl'],
      metadata: json['metadata'],
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  static NotificationType _parseNotificationType(dynamic type) {
    if (type == null) return NotificationType.system;
    if (type is NotificationType) return type;

    switch (type.toString().toLowerCase()) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'message':
        return NotificationType.message;
      case 'mention':
        return NotificationType.mention;
      default:
        return NotificationType.system;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'from_user': fromUser?.toJson(),
      'title': title,
      'message': message,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'metadata': metadata,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    UserModel? fromUser,
    String? title,
    String? message,
    String? imageUrl,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      fromUser: fromUser ?? this.fromUser,
      title: title ?? this.title,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    fromUser,
    title,
    message,
    imageUrl,
    actionUrl,
    metadata,
    isRead,
    createdAt,
  ];
}
