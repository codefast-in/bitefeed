import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

class BlockedUserModel extends Equatable {
  final String id;
  final UserModel user;
  final DateTime blockedAt;

  const BlockedUserModel({
    required this.id,
    required this.user,
    required this.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['_id'] ?? json['id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? json['blockedUser'] ?? {}),
      blockedAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, user, blockedAt];
}
