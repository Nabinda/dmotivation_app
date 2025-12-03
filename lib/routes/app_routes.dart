import 'package:dmotivation/dump/theme_demo.dart';
import 'package:dmotivation/features/dashboard/view/dashboard_screen.dart';
import 'package:dmotivation/features/onboarding/view/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/view/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dump',
        builder: (context, state) => const ThemeShowcaseScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
