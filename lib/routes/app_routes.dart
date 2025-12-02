import 'package:go_router/go_router.dart';
import '../../features/splash/view/splash_screen.dart';
// Note: We'll reference the Showcase screen from app.dart or a dedicated file later.
// For now, I will assume it's available or define the route to use it.
import '../../app.dart'; 

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        // Navigating to the ThemeShowcaseScreen which is currently inside app.dart
        builder: (context, state) => const ThemeShowcaseScreen(),
      ),
    ],
  );
}