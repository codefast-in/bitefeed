import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/storage_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/providers/post_provider.dart';
import 'features/bites/presentation/providers/bite_provider.dart';
import 'features/messages/presentation/providers/message_provider.dart';
import 'features/settings/presentation/providers/user_provider.dart';
import 'features/search/presentation/providers/search_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeServices();

  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  // Initialize storage
  await StorageService().init();

  // Initialize API client
  ApiClient().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core providers
        Provider<NetworkInfo>(create: (_) => NetworkInfo(Connectivity())),

        // Feature providers
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
        ChangeNotifierProvider<BiteProvider>(create: (_) => BiteProvider()),
        ChangeNotifierProvider<MessageProvider>(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'BiteFeed',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryRed,
                primary: AppColors.primaryRed,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.white,
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                textStyle: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            initialRoute: _getInitialRoute(authProvider),
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }

  String _getInitialRoute(AuthProvider authProvider) {
    // Show splash while checking auth state
    if (authProvider.state == AuthState.initial) {
      return AppRoutes.splash;
    }

    // If authenticated, go to main page
    if (authProvider.isAuthenticated) {
      return AppRoutes.main;
    }

    // Otherwise, show login
    return AppRoutes.login;
  }
}
