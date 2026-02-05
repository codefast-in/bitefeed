import 'package:flutter/material.dart';
import '../../data/repositories/search_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../home/data/models/post_model.dart';
import '../../../../core/network/api_exception.dart';

enum SearchState { initial, searching, loaded, error }

class SearchProvider extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchProvider({SearchRepository? searchRepository})
    : _searchRepository = searchRepository ?? SearchRepository();

  // State
  SearchState _state = SearchState.initial;
  String _query = '';
  List<UserModel> _users = [];
  List<PostModel> _posts = [];
  List<Map<String, dynamic>> _restaurants = [];
  String? _errorMessage;

  // Getters
  SearchState get state => _state;
  String get query => _query;
  List<UserModel> get users => _users;
  List<PostModel> get posts => _posts;
  List<Map<String, dynamic>> get restaurants => _restaurants;
  String? get errorMessage => _errorMessage;
  bool get isSearching => _state == SearchState.searching;
  bool get hasResults =>
      _users.isNotEmpty || _posts.isNotEmpty || _restaurants.isNotEmpty;

  // Search all
  Future<void> searchAll(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _query = query;
    _state = SearchState.searching;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _searchRepository.searchAll(query);

      _users = results['users'] as List<UserModel>;
      _posts = results['posts'] as List<PostModel>;
      _restaurants = results['restaurants'] as List<Map<String, dynamic>>;

      _state = SearchState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = SearchState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = SearchState.error;
      notifyListeners();
    }
  }

  // Search users only
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _query = query;
    _state = SearchState.searching;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _searchRepository.searchUsers(query);
      _posts = [];
      _restaurants = [];

      _state = SearchState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = SearchState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = SearchState.error;
      notifyListeners();
    }
  }

  // Search restaurants only
  Future<void> searchRestaurants(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _query = query;
    _state = SearchState.searching;
    _errorMessage = null;
    notifyListeners();

    try {
      _restaurants = await _searchRepository.searchRestaurants(query);
      _users = [];
      _posts = [];

      _state = SearchState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = SearchState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = SearchState.error;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _query = '';
    _users = [];
    _posts = [];
    _restaurants = [];
    _state = SearchState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
