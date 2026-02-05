import 'package:equatable/equatable.dart';
import '../../auth/data/models/user_model.dart';

class BiteModel extends Equatable {
  final String id;
  final String restaurantName;
  final List<String> photos;
  final double rating;
  final String? caption;
  final List<String> tags;
  final Map<String, dynamic>? restaurantLocation;
  final String status;
  final UserModel user;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BiteModel({
    required this.id,
    required this.restaurantName,
    required this.photos,
    required this.rating,
    this.caption,
    this.tags = const [],
    this.restaurantLocation,
    this.status = 'published',
    required this.user,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BiteModel.fromJson(Map<String, dynamic> json) {
    return BiteModel(
      id: json['_id'] ?? json['id'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      rating: (json['rating'] ?? 0).toDouble(),
      caption: json['caption'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      restaurantLocation: json['restaurantLocation'],
      status: json['status'] ?? 'published',
      user: json['userId'] != null
          ? UserModel.fromJson(json['userId'])
          : UserModel.fromJson(json['user'] ?? {}),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
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
      'restaurantName': restaurantName,
      'photos': photos,
      'rating': rating,
      'caption': caption,
      'tags': tags,
      'restaurantLocation': restaurantLocation,
      'status': status,
      'userId': user.toJson(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BiteModel copyWith({
    String? id,
    String? restaurantName,
    List<String>? photos,
    double? rating,
    String? caption,
    List<String>? tags,
    Map<String, dynamic>? restaurantLocation,
    String? status,
    UserModel? user,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BiteModel(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      photos: photos ?? this.photos,
      rating: rating ?? this.rating,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags,
      restaurantLocation: restaurantLocation ?? this.restaurantLocation,
      status: status ?? this.status,
      user: user ?? this.user,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    restaurantName,
    photos,
    rating,
    caption,
    tags,
    restaurantLocation,
    status,
    user,
    likesCount,
    commentsCount,
    isLiked,
    isBookmarked,
    createdAt,
    updatedAt,
  ];
}
