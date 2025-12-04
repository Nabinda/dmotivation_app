import 'package:go_router/go_router.dart';
import '../features/splash/view/splash_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../dump/theme_demo.dart';
import '../features/settings/view/settings_screen.dart';
import '../features/settings/view/paywall_screen.dart'; // Import Paywall
import '../features/settings/view/manage_subscription_screen.dart'; // Import Manage

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
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // NEW ROUTES
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/manage-subscription',
        builder: (context, state) => const ManageSubscriptionScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
