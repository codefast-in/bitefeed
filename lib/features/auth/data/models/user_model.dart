import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? username;
  final String? profileImage;
  final List<String> foodPreferences;
  final List<String> customFoodPreferences;
  final bool contactsSynced;
  final bool notificationsEnabled;
  final bool locationEnabled;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.username,
    this.profileImage,
    this.foodPreferences = const [],
    this.customFoodPreferences = const [],
    this.contactsSynced = false,
    this.notificationsEnabled = true,
    this.locationEnabled = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      profileImage: json['profileImage'],
      foodPreferences: json['foodPreferences'] != null
          ? List<String>.from(json['foodPreferences'])
          : [],
      customFoodPreferences: json['customFoodPreferences'] != null
          ? List<String>.from(json['customFoodPreferences'])
          : [],
      contactsSynced: json['contactsSynced'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      locationEnabled: json['locationEnabled'] ?? false,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'profileImage': profileImage,
      'foodPreferences': foodPreferences,
      'customFoodPreferences': customFoodPreferences,
      'contactsSynced': contactsSynced,
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'isFollowing': isFollowing,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? username,
    String? profileImage,
    List<String>? foodPreferences,
    List<String>? customFoodPreferences,
    bool? contactsSynced,
    bool? notificationsEnabled,
    bool? locationEnabled,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      customFoodPreferences:
          customFoodPreferences ?? this.customFoodPreferences,
      contactsSynced: contactsSynced ?? this.contactsSynced,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    username,
    profileImage,
    foodPreferences,
    customFoodPreferences,
    contactsSynced,
    notificationsEnabled,
    locationEnabled,
    followersCount,
    followingCount,
    isFollowing,
    createdAt,
    updatedAt,
  ];
}
