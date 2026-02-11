import 'package:flutter/material.dart';
import 'package:bitefeed/features/search/data/repositories/search_repository.dart';
import 'package:bitefeed/features/auth/data/models/user_model.dart';
import 'package:bitefeed/core/models/pagination_model.dart';
import 'package:bitefeed/features/bites/models/bite_model.dart';
import 'package:bitefeed/core/network/api_exception.dart';

enum SearchState { initial, searching, loaded, error }

class SearchProvider extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchProvider({SearchRepository? searchRepository})
    : _searchRepository = searchRepository ?? SearchRepository();

  // State
  SearchState _state = SearchState.initial;
  String _query = '';
  List<UserModel> _users = [];
  List<BiteModel> _bites = [];
  PaginationModel? _usersPagination;
  PaginationModel? _bitesPagination;
  String? _errorMessage;

  // Getters
  SearchState get state => _state;
  String get query => _query;
  List<UserModel> get users => _users;
  List<BiteModel> get bites => _bites;
  PaginationModel? get usersPagination => _usersPagination;
  PaginationModel? get bitesPagination => _bitesPagination;
  String? get errorMessage => _errorMessage;
  bool get isSearching => _state == SearchState.searching;
  bool get hasResults => _users.isNotEmpty || _bites.isNotEmpty;

  // Search users and bites (consolidated)
  Future<void> search(String query, {int page = 1, int limit = 10}) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _query = query;
    _state = SearchState.searching;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _searchRepository.searchUserAndBites(
        query,
        page: page,
        limit: limit,
      );

      if (page == 1) {
        _users = response.users;
        _bites = response.bites;
      } else {
        _users.addAll(response.users);
        _bites.addAll(response.bites);
      }

      _usersPagination = response.usersPagination;
      _bitesPagination = response.bitesPagination;

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
    _bites = [];
    _usersPagination = null;
    _bitesPagination = null;
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
