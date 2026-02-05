class StorageKeys {
  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String isLoggedIn = 'is_logged_in';

  // User Data
  static const String userData = 'user_data';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userPhone = 'user_phone';
  static const String userProfilePhoto = 'user_profile_photo';

  // Preferences
  static const String foodPreferences = 'food_preferences';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String locationEnabled = 'location_enabled';

  // Cache
  static const String cachedFeed = 'cached_feed';
  static const String cachedBites = 'cached_bites';
  static const String lastFeedUpdate = 'last_feed_update';

  // Onboarding
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String hasSeenPermissionPrompts = 'has_seen_permission_prompts';
}
