import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../settings/data/repositories/user_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/network/api_exception.dart';

enum UserState { initial, loading, loaded, updating, error }

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  UserProvider({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository();

  // State
  UserState _state = UserState.initial;
  UserModel? _currentUser;
  Map<String, UserModel> _usersCache = {};
  List<UserModel> _followers = [];
  List<UserModel> _following = [];
  String? _errorMessage;

  // Getters
  UserState get state => _state;
  UserModel? get currentUser => _currentUser;
  List<UserModel> get followers => _followers;
  List<UserModel> get following => _following;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == UserState.loading;
  bool get isUpdating => _state == UserState.updating;

  UserModel? getUserById(String userId) => _usersCache[userId];

  // Load current user profile
  Future<void> loadUserProfile() async {
    _state = UserState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userRepository.getUserProfile();
      _currentUser = user;
      _usersCache[user.id] = user;
      _state = UserState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = UserState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = UserState.error;
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? bio,
    String? location,
    List<String>? foodPreferences,
  }) async {
    _state = UserState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userRepository.updateProfile(
        fullName: name,
        foodPreferences: foodPreferences,
      );

      _currentUser = updatedUser;
      _usersCache[updatedUser.id] = updatedUser;
      _state = UserState.loaded;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = UserState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = UserState.error;
      notifyListeners();
      return false;
    }
  }

  // Upload profile photo
  Future<String?> uploadProfilePhoto(XFile image) async {
    _state = UserState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Upload image first
      final urls = await _userRepository.uploadImages([image]);
      final photoUrl = urls.isNotEmpty ? urls.first : null;

      if (photoUrl == null) {
        throw const UnknownException('Failed to upload image');
      }

      // Update profile with new photo URL
      final updatedUser = await _userRepository.updateProfile(
        profileImage: photoUrl,
      );

      _currentUser = updatedUser;
      _usersCache[updatedUser.id] = updatedUser;

      _state = UserState.loaded;
      notifyListeners();
      return photoUrl;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = UserState.error;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = UserState.error;
      notifyListeners();
      return null;
    }
  }

  // Load followers (not implemented in backend yet)
  Future<void> loadFollowers(String userId) async {
    // TODO: Implement when backend API is available
    _errorMessage = 'Followers API not yet implemented';
  }

  // Load following (not implemented in backend yet)
  Future<void> loadFollowing(String userId) async {
    // TODO: Implement when backend API is available
    _errorMessage = 'Following API not yet implemented';
  }

  // Follow user
  Future<bool> followUser(String userId) async {
    try {
      await _userRepository.toggleFollow(userId);

      // Update user in cache
      if (_usersCache.containsKey(userId)) {
        _usersCache[userId] = _usersCache[userId]!.copyWith(
          isFollowing: true,
          followersCount: _usersCache[userId]!.followersCount + 1,
        );
      }

      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Unfollow user
  Future<bool> unfollowUser(String userId) async {
    try {
      await _userRepository.toggleFollow(userId);

      // Update user in cache
      if (_usersCache.containsKey(userId)) {
        _usersCache[userId] = _usersCache[userId]!.copyWith(
          isFollowing: false,
          followersCount: _usersCache[userId]!.followersCount - 1,
        );
      }

      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _state = UserState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Change password not implemented in backend yet
      throw const UnknownException('Change password API not yet implemented');

      _state = UserState.loaded;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = UserState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = UserState.error;
      notifyListeners();
      return false;
    }
  }

  // Set current user (from auth)
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    _usersCache[user.id] = user;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
