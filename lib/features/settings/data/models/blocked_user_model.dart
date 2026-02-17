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
    final nestedUser = json['user'] ?? json['blockedUser'];
    final userPayload = nestedUser ?? json;
    return BlockedUserModel(
      id: json['_id'] ?? json['id'] ?? userPayload['_id'] ?? '',
      user: UserModel.fromJson(userPayload ?? {}),
      blockedAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, user, blockedAt];
}
