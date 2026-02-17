import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../settings/data/repositories/user_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/storage/storage_keys.dart';
import 'package:bitefeed/features/auth/presentation/providers/auth_provider.dart';
import 'package:bitefeed/features/settings/data/models/other_user_profile_model.dart';
import 'package:bitefeed/features/settings/data/models/blocked_user_model.dart';
import 'package:bitefeed/core/models/pagination_model.dart';

enum UserState { initial, loading, loaded, updating, error }

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  final StorageService _storage;
  AuthProvider? _authProvider;

  UserProvider({UserRepository? userRepository, StorageService? storage})
    : _userRepository = userRepository ?? UserRepository(),
      _storage = storage ?? StorageService();

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
    // Sync current user from AuthProvider. Reset and sync if user changed.
    if (authProvider.currentUser?.id != _currentUser?.id) {
      debugPrint(
        '🔄 UserProvider: User changed from ${_currentUser?.fullName} to ${authProvider.currentUser?.fullName}. Refreshing session...',
      );
      if (authProvider.currentUser == null) {
        clearData();
      } else {
        _currentUser = authProvider.currentUser;
        _usersCache.clear();
        if (_currentUser != null) {
          _usersCache[_currentUser!.id] = _currentUser!;
        }
        // Load fresh data for the new user
        loadUserProfile();
      }
    }
  }

  // State
  UserState _state = UserState.initial;
  UserModel? _currentUser;
  Map<String, UserModel> _usersCache = {};
  List<UserModel> _followers = [];
  List<UserModel> _following = [];
  OtherUserProfileModel? _otherUserProfile;
  List<BlockedUserModel> _blockedUsers = [];
  PaginationModel? _blockedPagination;
  String? _errorMessage;
  UserModel? get currentUser => _currentUser;
  List<UserModel> get followers => _followers;
  List<UserModel> get following => _following;
  OtherUserProfileModel? get otherUserProfile => _otherUserProfile;
  List<BlockedUserModel> get blockedUsers => _blockedUsers;
  PaginationModel? get blockedPagination => _blockedPagination;
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

      // Persist to storage
      await _storage.setJson(StorageKeys.userData, user.toJson());

      // Sync with AuthProvider
      _authProvider?.setCurrentUser(user);

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

  // Upload generic image
  Future<String?> uploadImage(XFile image) async {
    _state = UserState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      final urls = await _userRepository.uploadImages([image]);
      if (urls.isNotEmpty) {
        _state = UserState.loaded;
        notifyListeners();
        return urls.first;
      }
      _state = UserState.loaded;
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      _errorMessage = 'Failed to upload image';
      _state = UserState.error;
      notifyListeners();
      return null;
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? username,
    String? email,
    String? bio, // Kept for compatibility but not used in API currently
    String? location, // Kept for compatibility but not used in API currently
    List<String>? foodPreferences,
    List<String>? customFoodPreferences,
    bool? contactsSynced,
    bool? notificationsEnabled,
    bool? locationEnabled,
    String? profileImage,
  }) async {
    _state = UserState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userRepository.updateProfile(
        fullName: name ?? _currentUser?.fullName,
        username: username ?? _currentUser?.username,
        email: email ?? _currentUser?.email,
        foodPreferences: foodPreferences ?? _currentUser?.foodPreferences,
        customFoodPreferences:
            customFoodPreferences ?? _currentUser?.customFoodPreferences,
        contactsSynced: contactsSynced ?? _currentUser?.contactsSynced,
        notificationsEnabled:
            notificationsEnabled ?? _currentUser?.notificationsEnabled,
        locationEnabled: locationEnabled ?? _currentUser?.locationEnabled,
        profileImage: profileImage ?? _currentUser?.profileImage,
      );

      _currentUser = updatedUser;
      _usersCache[updatedUser.id] = updatedUser;

      // Persist to storage
      await _storage.setJson(StorageKeys.userData, updatedUser.toJson());

      // Sync with AuthProvider
      _authProvider?.setCurrentUser(updatedUser);

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

      // Persist to storage
      await _storage.setJson(StorageKeys.userData, updatedUser.toJson());

      // Sync with AuthProvider
      _authProvider?.setCurrentUser(updatedUser);

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

  // Toggle follow user
  Future<bool> toggleFollowUser(String userId) async {
    try {
      await _userRepository.toggleFollow(userId);

      // Update local state if it's the other user profile being viewed
      if (_otherUserProfile != null &&
          _otherUserProfile!.profile.id == userId) {
        final currentlyFollowing = _otherUserProfile!.profile.isFollowing;
        final updatedProfile = _otherUserProfile!.profile.copyWith(
          isFollowing: !currentlyFollowing,
          followersCount: currentlyFollowing
              ? (_otherUserProfile!.profile.followersCount - 1)
                    .clamp(0, 999999)
                    .toInt()
              : _otherUserProfile!.profile.followersCount + 1,
        );
        _otherUserProfile = OtherUserProfileModel(
          profile: updatedProfile,
          bites: _otherUserProfile!.bites,
          pagination: _otherUserProfile!.pagination,
        );
      }

      // Also update cache if exists
      if (_usersCache.containsKey(userId)) {
        final currentlyFollowing = _usersCache[userId]!.isFollowing;
        _usersCache[userId] = _usersCache[userId]!.copyWith(
          isFollowing: !currentlyFollowing,
        );
      }

      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  // Load other user profile
  Future<void> loadOtherUserProfile(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    _state = UserState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _userRepository.getOtherUserProfile(
        userId,
        page: page,
        limit: limit,
      );
      _otherUserProfile = profile;
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

  // Toggle block user
  Future<bool> toggleBlockUser(String targetUserId) async {
    try {
      await _userRepository.toggleBlockUser(targetUserId);

      _blockedUsers.removeWhere((b) => b.user.id == targetUserId || b.id == targetUserId);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Load blocked users
  Future<void> loadBlockedUsers({int page = 1, int limit = 10}) async {
    _state = UserState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _userRepository.getBlockedUsers(
        page: page,
        limit: limit,
      );
      if (page == 1) {
        _blockedUsers = response['users'] as List<BlockedUserModel>;
      } else {
        _blockedUsers.addAll(response['users'] as List<BlockedUserModel>);
      }
      _blockedPagination = response['pagination'] as PaginationModel;

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

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _state = UserState.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement when backend API is available
      _errorMessage = 'Change password API not yet implemented';
      _state = UserState.error;
      notifyListeners();
      return false;
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

  // Reset all state (useful on logout/signup)
  void clearData() {
    _currentUser = null;
    _usersCache.clear();
    _followers.clear();
    _following.clear();
    _otherUserProfile = null;
    _blockedUsers.clear();
    _blockedPagination = null;
    _errorMessage = null;
    _state = UserState.initial;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
