import 'package:flutter/material.dart';
import '../../../home/data/repositories/post_repository.dart';
import '../../../home/data/models/post_model.dart';
import '../../../../core/network/api_exception.dart';

enum PostsState { initial, loading, loaded, loadingMore, refreshing, error }

class PostProvider extends ChangeNotifier {
  final PostRepository _postRepository;

  PostProvider({PostRepository? postRepository})
    : _postRepository = postRepository ?? PostRepository();

  // State
  PostsState _state = PostsState.initial;
  List<PostModel> _posts = [];
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  PostsState get state => _state;
  List<PostModel> get posts => _posts;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _state == PostsState.loading;
  bool get isLoadingMore => _state == PostsState.loadingMore;
  bool get isRefreshing => _state == PostsState.refreshing;

  // Load feed
  Future<void> loadFeed({bool refresh = false}) async {
    if (refresh) {
      _state = PostsState.refreshing;
      _currentPage = 1;
      _hasMore = true;
    } else if (_state == PostsState.loading ||
        _state == PostsState.loadingMore) {
      return; // Prevent multiple simultaneous loads
    } else {
      _state = PostsState.loading;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      final newPosts = await _postRepository.getFeed(page: _currentPage);

      if (refresh) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }

      _hasMore = newPosts.length >= 20; // Assuming page size is 20
      _state = PostsState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = PostsState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = PostsState.error;
      notifyListeners();
    }
  }

  // Load more posts (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _state == PostsState.loadingMore) return;

    _state = PostsState.loadingMore;
    _currentPage++;
    notifyListeners();

    try {
      final newPosts = await _postRepository.getFeed(page: _currentPage);
      _posts.addAll(newPosts);
      _hasMore = newPosts.length >= 20;
      _state = PostsState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _currentPage--; // Revert page increment
      _state = PostsState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _currentPage--;
      _state = PostsState.error;
      notifyListeners();
    }
  }

  // Refresh feed
  Future<void> refresh() async {
    await loadFeed(refresh: true);
  }

  // Like post
  Future<void> likePost(String postId) async {
    try {
      // Optimistic update
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          isLiked: true,
          likesCount: _posts[index].likesCount + 1,
        );
        notifyListeners();
      }

      await _postRepository.likePost(postId);
    } on AppException catch (e) {
      // Revert on error
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          isLiked: false,
          likesCount: _posts[index].likesCount - 1,
        );
        notifyListeners();
      }
      _errorMessage = e.message;
    }
  }

  // Unlike post
  Future<void> unlikePost(String postId) async {
    try {
      // Optimistic update
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          isLiked: false,
          likesCount: _posts[index].likesCount - 1,
        );
        notifyListeners();
      }

      await _postRepository.unlikePost(postId);
    } on AppException catch (e) {
      // Revert on error
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          isLiked: true,
          likesCount: _posts[index].likesCount + 1,
        );
        notifyListeners();
      }
      _errorMessage = e.message;
    }
  }

  // Save post
  Future<void> savePost(String postId) async {
    try {
      // Optimistic update
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(isSaved: true);
        notifyListeners();
      }

      await _postRepository.savePost(postId);
    } on AppException catch (e) {
      // Revert on error
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(isSaved: false);
        notifyListeners();
      }
      _errorMessage = e.message;
    }
  }

  // Unsave post
  Future<void> unsavePost(String postId) async {
    try {
      // Optimistic update
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(isSaved: false);
        notifyListeners();
      }

      await _postRepository.unsavePost(postId);
    } on AppException catch (e) {
      // Revert on error
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(isSaved: true);
        notifyListeners();
      }
      _errorMessage = e.message;
    }
  }

  // Delete post
  Future<bool> deletePost(String postId) async {
    try {
      await _postRepository.deletePost(postId);
      _posts.removeWhere((p) => p.id == postId);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
