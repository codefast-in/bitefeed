class ApiEndpoints {
  // Base paths
  static const String users = '/users';
  static const String bites = '/bites';

  // Auth endpoints (under /users)
  static const String login = '$users/login';
  static const String register = '$users/register';
  static const String forgotPassword = '$users/forgot-password';
  static const String verifyCode = '$users/verify-code';
  static const String resetPassword = '$users/reset-password';

  // User endpoints
  static const String profile = '$users/profile';
  static const String updateProfile = '$users/profile';
  static const String uploadImages = '$users/upload-images';
  static const String followUser = '$users/follow';
  static const String chatThreads = '$users/chat-threads';

  // Bite endpoints
  static const String biteFeed = '$bites/feed';
  static const String myBites = '$bites/mybites';
  static const String createBite = bites;
  static const String likeBite = '$bites/like';
  static const String bookmarkBite = '$bites/bookmark';
  static const String commentBite = '$bites/comment';
  static const String deleteBite = bites; // + /{restaurantId}
  static const String searchRestaurants = '/restaurants/search';

  // Messages
  static const String conversations = '/messages/conversations';
  static const String messages = '/messages'; // + /{conversationId}
  static const String sendMessage = '/messages/send';
  static const String createConversation = '/messages/conversation/create';
  static const String createGroupChat = '/messages/group/create';
  static const String addGroupMembers = '/messages/group/add-members';
  static const String removeGroupMember = '/messages/group/remove-member';
  static const String leaveGroup = '/messages/group/leave';
  static const String groupMembers = '/messages/group/members'; // + /{groupId}

  // Notifications
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/read'; // + /{notificationId}
  static const String markAllAsRead = '/notifications/read-all';
  static const String notificationSettings = '/notifications/settings';

  // Search
  static const String search = '/search';
  static const String searchAll = '/search/all';

  // Upload
  static const String uploadImage = '/upload/image';
  static const String uploadMultipleImages = '/upload/images';

  // Food Preferences
  static const String foodPreferences = '/user/food-preferences';
  static const String updateFoodPreferences = '/user/food-preferences/update';

  // Settings
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';
  static const String reportBug = '/support/report-bug';
  static const String contactSupport = '/support/contact';
  static const String faq = '/support/faq';

  static const String feed = '/feed';
  static const String postDetails = '/post';

  static const String userPosts = '/user/posts';
static const String likePost = '/post/like';
  static const String unlikePost = '/post/unlike';
static const String savePost = '/post/save';
  static const String unsavePost = '/post/unsave';
static const String savedPosts = '/saved-posts';
  static const String deletePost = '/post';
static const String searchUsers = '/searchUsers';


  // Helper method to build URL with ID
  static String withId(String endpoint, String id) => '$endpoint/$id';

  // Helper method to build URL with query parameters
  static String withQuery(String endpoint, Map<String, dynamic> params) {
    if (params.isEmpty) return endpoint;
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return '$endpoint?$query';
  }
}
