import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait for auth initialization (already happening in main.dart)
    await Future.delayed(const Duration(milliseconds: 500));

    // Wait minimum 2 seconds for splash visibility
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    debugPrint(
      '🚀 SplashScreen: Auth state = ${authProvider.state}, isAuthenticated = ${authProvider.isAuthenticated}',
    );

    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      debugPrint('✅ SplashScreen: Navigating to main page');
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else {
      debugPrint('❌ SplashScreen: Navigating to login page');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFA10A), Color(0xFFDA2744)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/fullLogo.png',
                width: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
