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
  final bool
  isFollowing; // Added this one back too just in case, though it's in the constructor
  final DateTime createdAt;
  final DateTime updatedAt;

  // New field
  final List<String> followers;
  final List<String> following;
  final String? role;
  final String? status;
  final bool profileSetupComplete;

  // Derived properties for counts
  int get followersCount => followers.length;
  int get followingCount => following.length;

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
    this.followers = const [],
    this.following = const [],
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
      'username': username,
      'profileImage': profileImage,
      'foodPreferences': foodPreferences,
      'customFoodPreferences': customFoodPreferences,
      'contactsSynced': contactsSynced,
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'followers': followers,
      'following': following,
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
    String? username,
    String? profileImage,
    List<String>? foodPreferences,
    List<String>? customFoodPreferences,
    bool? contactsSynced,
    bool? notificationsEnabled,
    bool? locationEnabled,
    List<String>? followers,
    List<String>? following,
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
    username,
    profileImage,
    foodPreferences,
    customFoodPreferences,
    contactsSynced,
    notificationsEnabled,
    locationEnabled,
    followers,
    following,
    role,
    status,
    profileSetupComplete,
    isFollowing,
    createdAt,
    updatedAt,
  ];
}
