import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';

class PostModel extends Equatable {
  final String id;
  final UserModel user;
  final String restaurantName;
  final String? restaurantLocation;
  final List<String> imageUrls;
  final double rating;
  final String description;
  final List<String> hashtags;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;
  final String? distance; // e.g., "0.8 Mi"

  const PostModel({
    required this.id,
    required this.user,
    required this.restaurantName,
    this.restaurantLocation,
    required this.imageUrls,
    required this.rating,
    required this.description,
    this.hashtags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
    this.distance,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? json['_id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      restaurantName: json['restaurant_name'] ?? json['restaurantName'] ?? '',
      restaurantLocation:
          json['restaurant_location'] ?? json['restaurantLocation'],
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'])
          : json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : [],
      rating: (json['rating'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags'])
          : [],
      likesCount: json['likes_count'] ?? json['likesCount'] ?? 0,
      commentsCount: json['comments_count'] ?? json['commentsCount'] ?? 0,
      sharesCount: json['shares_count'] ?? json['sharesCount'] ?? 0,
      isLiked: json['is_liked'] ?? json['isLiked'] ?? false,
      isSaved: json['is_saved'] ?? json['isSaved'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'restaurant_name': restaurantName,
      'restaurant_location': restaurantLocation,
      'image_urls': imageUrls,
      'rating': rating,
      'description': description,
      'hashtags': hashtags,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'is_liked': isLiked,
      'is_saved': isSaved,
      'created_at': createdAt.toIso8601String(),
      'distance': distance,
    };
  }

  PostModel copyWith({
    String? id,
    UserModel? user,
    String? restaurantName,
    String? restaurantLocation,
    List<String>? imageUrls,
    double? rating,
    String? description,
    List<String>? hashtags,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isSaved,
    DateTime? createdAt,
    String? distance,
  }) {
    return PostModel(
      id: id ?? this.id,
      user: user ?? this.user,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantLocation: restaurantLocation ?? this.restaurantLocation,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      hashtags: hashtags ?? this.hashtags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
      distance: distance ?? this.distance,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    restaurantName,
    restaurantLocation,
    imageUrls,
    rating,
    description,
    hashtags,
    likesCount,
    commentsCount,
    sharesCount,
    isLiked,
    isSaved,
    createdAt,
    distance,
  ];
}
