import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? username;
  final String? profileImage;
  final List<String> foodPreferences;
  final List<String> customFoodPreferences;
  final bool contactsSynced;
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool
  isFollowing; // Added this one back too just in case, though it's in the constructor
  final DateTime createdAt;
  final DateTime updatedAt;

  // New fields from API
  final List<String> followers;
  final List<String> following;
  final int followersCount;
  final int followingCount;
  final int bitesCount;
  final String? role;
  final String? status;
  final bool profileSetupComplete;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.username,
    this.profileImage,
    this.foodPreferences = const [],
    this.customFoodPreferences = const [],
    this.contactsSynced = false,
    this.notificationsEnabled = true,
    this.locationEnabled = false,
    this.followers = const [],
    this.following = const [],
    this.followersCount = 0,
    this.followingCount = 0,
    this.bitesCount = 0,
    this.role,
    this.status,
    this.profileSetupComplete = false,
    this.isFollowing = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'],
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
      followers: json['followers'] != null
          ? List<String>.from(json['followers'])
          : [],
      following: json['following'] != null
          ? List<String>.from(json['following'])
          : [],
      followersCount:
          json['followersCount'] ?? (json['followers'] as List?)?.length ?? 0,
      followingCount:
          json['followingCount'] ?? (json['following'] as List?)?.length ?? 0,
      bitesCount: json['bitesCount'] ?? 0,
      role: json['role'],
      status: json['status'],
      profileSetupComplete: json['profileSetupComplete'] ?? false,
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
      'phoneNumber': phoneNumber,
      'username': username,
      'profileImage': profileImage,
      'foodPreferences': foodPreferences,
      'customFoodPreferences': customFoodPreferences,
      'contactsSynced': contactsSynced,
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'followers': followers,
      'following': following,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'bitesCount': bitesCount,
      'role': role,
      'status': status,
      'profileSetupComplete': profileSetupComplete,
      'isFollowing': isFollowing,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? username,
    String? profileImage,
    List<String>? foodPreferences,
    List<String>? customFoodPreferences,
    bool? contactsSynced,
    bool? notificationsEnabled,
    bool? locationEnabled,
    List<String>? followers,
    List<String>? following,
    int? followersCount,
    int? followingCount,
    int? bitesCount,
    String? role,
    String? status,
    bool? profileSetupComplete,
    bool? isFollowing,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      customFoodPreferences:
          customFoodPreferences ?? this.customFoodPreferences,
      contactsSynced: contactsSynced ?? this.contactsSynced,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      bitesCount: bitesCount ?? this.bitesCount,
      role: role ?? this.role,
      status: status ?? this.status,
      profileSetupComplete: profileSetupComplete ?? this.profileSetupComplete,
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
    phoneNumber,
    username,
    profileImage,
    foodPreferences,
    customFoodPreferences,
    contactsSynced,
    notificationsEnabled,
    locationEnabled,
    followers,
    following,
    followersCount,
    followingCount,
    bitesCount,
    role,
    status,
    profileSetupComplete,
    isFollowing,
    createdAt,
    updatedAt,
  ];
}
