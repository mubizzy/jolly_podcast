import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_provider.dart';
import 'controllers/episodes_controller.dart';
import 'controllers/categories_controller.dart';
import 'views/splash_screen.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EpisodesController()),
        ChangeNotifierProvider(create: (_) => CategoriesController()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppInitializer(),
      ),
    );
  }
}

// Widget to check auth state on app startup
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Schedule auth check after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    // Initialize auth provider (checks for saved token)
    await context.read<AuthProvider>().initialize();

    if (!mounted) return;

    // Navigate based on auth state
    final isAuthenticated = context.read<AuthProvider>().isAuthenticated;

    // Small delay to show splash screen
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (isAuthenticated) {
      // User is logged in, go to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // User is not logged in, go to splash/login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking auth
    return const Scaffold(
      backgroundColor: Color(0xFF0A1F1F),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD4E157),
        ),
      ),
    );
  }
}
