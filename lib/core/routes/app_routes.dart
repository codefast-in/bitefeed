import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verification_code_page.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../../features/auth/presentation/pages/password_changed_success_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String passwordChangedSuccess = '/password-changed-success';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    verificationCode: (context) => const VerificationCodePage(),
    createNewPassword: (context) => const CreateNewPasswordPage(),
    passwordChangedSuccess: (context) => const PasswordChangedSuccessPage(),
  };
}
