import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verification_code_page.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../features/auth/presentation/pages/password_changed_success_page.dart';
import '../../features/auth/presentation/pages/create_profile_page.dart';
import '../../features/auth/presentation/pages/food_preferences_page.dart';
import '../../features/auth/presentation/pages/find_friends_page.dart';
import '../../features/auth/presentation/pages/notification_permission_page.dart';
import '../../features/auth/presentation/pages/location_permission_page.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/home/presentation/pages/post_details_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/bites/presentation/pages/send_to_page.dart';
import '../../features/settings/presentation/pages/edit_profile_page.dart';
import '../../features/settings/presentation/pages/change_password_page.dart';
import '../../features/settings/presentation/pages/block_list_page.dart';
import '../../features/settings/presentation/pages/help_support_page.dart';
import '../../features/settings/presentation/pages/faq_page.dart';
import '../../features/settings/presentation/pages/report_bug_page.dart';
import '../../features/settings/presentation/pages/contact_us_page.dart';
import '../../features/settings/presentation/pages/followers_page.dart';
import '../../features/settings/presentation/pages/following_page.dart';
import '../../features/settings/presentation/pages/user_details_page.dart';
import '../../features/settings/presentation/pages/my_posts_page.dart';
import '../../features/messages/presentation/pages/chat_page.dart';
import '../../features/messages/presentation/pages/group_members_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String passwordChangedSuccess = '/password-changed-success';
  static const String createProfile = '/create-profile';
  static const String foodPreferences = '/food-preferences';
  static const String findFriends = '/find-friends';
  static const String notificationPermission = '/notification-permission';
  static const String locationPermission = '/location-permission';
  static const String main = '/main';
  static const String postDetails = '/post-details';
  static const String settings = '/settings';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String sendTo = '/send-to';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String blockList = '/block-list';
  static const String helpSupport = '/help-support';
  static const String faq = '/faq';
  static const String reportBug = '/report-bug';
  static const String contactUs = '/contact-us';
  static const String followers = '/followers';
  static const String following = '/following';
  static const String userDetails = '/user-details';
  static const String myPosts = '/my-posts';
  static const String chat = '/chat';
  static const String groupMembers = '/group-members';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    verificationCode: (context) => const VerificationCodePage(),
    createNewPassword: (context) => const CreateNewPasswordPage(),
    passwordChangedSuccess: (context) => const PasswordChangedSuccessPage(),
    createProfile: (context) => const CreateProfilePage(),
    foodPreferences: (context) => const FoodPreferencesPage(),
    findFriends: (context) => const FindFriendsPage(),
    notificationPermission: (context) => const NotificationPermissionPage(),
    locationPermission: (context) => const LocationPermissionPage(),
    main: (context) => const MainPage(),
    postDetails: (context) => const PostDetailsPage(),
    settings: (context) => const SettingsPage(),
    search: (context) => const SearchPage(),
    notifications: (context) => const NotificationsPage(),
    sendTo: (context) => const SendToPage(),
    editProfile: (context) => const EditProfilePage(),
    changePassword: (context) => const ChangePasswordPage(),
    blockList: (context) => const BlockListPage(),
    helpSupport: (context) => const HelpSupportPage(),
    faq: (context) => const FaqPage(),
    reportBug: (context) => const ReportBugPage(),
    contactUs: (context) => const ContactUsPage(),
    followers: (context) => const FollowersPage(),
    following: (context) => const FollowingPage(),
    userDetails: (context) => const UserDetailsPage(),
    myPosts: (context) => const MyPostsPage(),
    chat: (context) => const ChatPage(),
    groupMembers: (context) => const GroupMembersPage(),
  };
}
