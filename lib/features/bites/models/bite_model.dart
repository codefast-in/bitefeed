import 'package:equatable/equatable.dart';
import '../../auth/data/models/user_model.dart';

class BiteComment extends Equatable {
  final String id;
  final UserModel user;
  final String text;
  final DateTime createdAt;

  const BiteComment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  factory BiteComment.fromJson(Map<String, dynamic> json) {
    return BiteComment(
      id: json['_id'] ?? json['id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? json['userId'] ?? {}),
      text: json['text'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, user, text, createdAt];
}

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
  final List<BiteComment> comments;
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
    this.comments = const [],
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BiteModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    // Handle likes - can be array of user IDs or count
    int likesCount = 0;
    bool isLiked = false;

    if (json['likes'] != null) {
      if (json['likes'] is List) {
        final likesList = List<dynamic>.from(json['likes']);
        likesCount = likesList.length;
        if (currentUserId != null) {
          isLiked = likesList.any(
            (l) =>
                (l is String && l == currentUserId) ||
                (l is Map &&
                    (l['_id'] == currentUserId || l['id'] == currentUserId)),
          );
        } else {
          isLiked = json['isLiked'] ?? json['liked'] ?? false;
        }
      } else if (json['likes'] is int) {
        likesCount = json['likes'];
        isLiked = json['isLiked'] ?? json['liked'] ?? false;
      }
    } else {
      likesCount = json['likesCount'] ?? 0;
      isLiked = json['isLiked'] ?? json['liked'] ?? false;
    }

    // Handle bookmarks - can be array of user IDs or boolean
    bool isBookmarked = false;
    if (json['bookmarks'] != null) {
      if (json['bookmarks'] is List) {
        final bookmarksList = List<dynamic>.from(json['bookmarks']);
        if (currentUserId != null) {
          isBookmarked = bookmarksList.any(
            (b) =>
                (b is String && b == currentUserId) ||
                (b is Map &&
                    (b['_id'] == currentUserId || b['id'] == currentUserId)),
          );
        } else {
          isBookmarked = json['isBookmarked'] ?? json['bookmarked'] ?? false;
        }
      } else {
        isBookmarked =
            json['isBookmarked'] ??
            json['bookmarked'] ??
            json['bookmarks'] ??
            false;
      }
    } else {
      isBookmarked = json['isBookmarked'] ?? json['bookmarked'] ?? false;
    }

    // Handle comments
    List<BiteComment> comments = [];
    int commentsCount = 0;
    if (json['comments'] != null) {
      if (json['comments'] is List) {
        final commentsList = json['comments'] as List;
        if (commentsList.isNotEmpty && commentsList.first is Map) {
          comments = commentsList
              .map((c) => BiteComment.fromJson(c as Map<String, dynamic>))
              .toList();
          commentsCount = comments.length;
        } else {
          commentsCount = commentsList.length;
        }
      } else {
        commentsCount = (json['comments'] ?? 0) as int;
      }
    } else {
      commentsCount = (json['commentsCount'] ?? 0) as int;
    }

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
      likesCount: likesCount,
      commentsCount: commentsCount,
      comments: comments,
      isLiked: isLiked,
      isBookmarked: isBookmarked,
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
      // 'comments': comments.map((c) => c.toJson()).toList(), // If needed
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
    List<BiteComment>? comments,
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
      comments: comments ?? this.comments,
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
    comments,
    isLiked,
    isBookmarked,
    createdAt,
    updatedAt,
  ];
}
