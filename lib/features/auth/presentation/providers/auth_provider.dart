import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../../../core/network/api_exception.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  // State
  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  // OTP and preferences (for signup flow)
  String _otp = '';
  final List<String> _selectedPreferences = [];
  final List<String> _availablePreferences = [
    'Vegetarian',
    'Coffee Lover',
    'Vegan',
    'Dessert Lover',
    'Street Food',
    'Healthy',
  ];

  // Getters
  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;
  String get otp => _otp;
  List<String> get selectedPreferences => _selectedPreferences;
  List<String> get availablePreferences => _availablePreferences;

  // Initialize - check if user is already logged in
  Future<void> initialize() async {
    debugPrint('🔐 AuthProvider: Initializing, checking auth status...');
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      debugPrint('🔐 AuthProvider: isLoggedIn = $isLoggedIn');

      if (isLoggedIn) {
        _currentUser = await _authRepository.getCurrentUser();
        debugPrint(
          '🔐 AuthProvider: User loaded - ${_currentUser?.fullName} (${_currentUser?.email})',
        );
        _state = AuthState.authenticated;
      } else {
        debugPrint('🔐 AuthProvider: No valid session found');
        _state = AuthState.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ AuthProvider: Initialize error - $e');
      _state = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    debugPrint('🔐 AuthProvider: Login attempt for $email');
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );

      _currentUser = authResponse.user;
      debugPrint(
        '✅ AuthProvider: Login successful - ${_currentUser?.fullName}',
      );
      debugPrint(
        '🔐 AuthProvider: Token saved: ${authResponse.accessToken.substring(0, 20)}...',
      );
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      debugPrint('❌ AuthProvider: Login failed - ${e.message}');
      _errorMessage = e.message;
      _state = AuthState.error;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('❌ AuthProvider: Login error - $e');
      _errorMessage = 'An unexpected error occurred';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // Signup
  Future<bool> signup({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    debugPrint('🔐 AuthProvider: Signup attempt for $email');
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authRepository.signup(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      _currentUser = authResponse.user;
      debugPrint(
        '✅ AuthProvider: Signup successful - ${_currentUser?.fullName}',
      );
      debugPrint(
        '🔐 AuthProvider: Token saved: ${authResponse.accessToken.substring(0, 20)}...',
      );
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      debugPrint('❌ AuthProvider: Signup failed - ${e.message}');
      _errorMessage = e.message;
      _state = AuthState.error;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('❌ AuthProvider: Signup error - $e');
      _errorMessage = 'An unexpected error occurred';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // Verify Code
  Future<Map<String, dynamic>?> verifyCode({
    required String email,
    required String code,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.verifyCode(email: email, code: code);
      _state = AuthState.unauthenticated;
      notifyListeners();
      return result;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = AuthState.error;
      notifyListeners();
      return null;
    }
  }

  // Forgot Password
  Future<bool> forgotPassword({required String email}) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.forgotPassword(email: email);
      _state = AuthState.unauthenticated;
      notifyListeners();
      return success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.resetPassword(
        email: email,
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _state = AuthState.unauthenticated;
      notifyListeners();
      return success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    debugPrint('🔐 AuthProvider: Logout initiated');
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _authRepository.logout();
      _currentUser = null;
      debugPrint('✅ AuthProvider: Logout successful, tokens cleared');
      _state = AuthState.unauthenticated;
      notifyListeners();
    } catch (e) {
      debugPrint(
        '⚠️ AuthProvider: Logout API failed, clearing local data anyway',
      );
      // Even if API call fails, clear local data
      _currentUser = null;
      _state = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  // OTP management
  void setOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  // Food preferences management
  void togglePreference(String preference) {
    if (_selectedPreferences.contains(preference)) {
      _selectedPreferences.remove(preference);
    } else {
      _selectedPreferences.add(preference);
    }
    notifyListeners();
  }

  void addCustomPreference(String preference) {
    if (preference.isNotEmpty && !_availablePreferences.contains(preference)) {
      _availablePreferences.add(preference);
      _selectedPreferences.add(preference);
      notifyListeners();
    }
  }

  // Set current user (after profile update)
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _currentUser != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;
    }
    notifyListeners();
  }
}
