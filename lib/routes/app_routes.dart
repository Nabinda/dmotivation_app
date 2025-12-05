import 'package:dmotivation/features/onboarding/bloc/onboarding_cubit.dart';
import 'package:dmotivation/features/onboarding/view/strategy_review_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/view/splash_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../dump/theme_demo.dart';
import '../features/settings/view/settings_screen.dart';
import '../features/settings/view/paywall_screen.dart';
import '../features/settings/view/manage_subscription_screen.dart';
import '../features/analytics/view/tactical_analytics_screen.dart';
import '../features/panic/view/panic_logs_screen.dart';

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
        path: '/strategy-review',
        builder: (context, state) {
          final cubit = state.extra as OnboardingCubit;
          return StrategyReviewScreen(onboardingCubit: cubit);
        },
      ),
      GoRoute(
        path: '/dump',
        builder: (context, state) => const ThemeShowcaseScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
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
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const TacticalAnalyticsScreen(),
      ),
      GoRoute(
        path: '/panic-logs',
        builder: (context, state) => const PanicLogsScreen(),
      ),
    ],
  );
}
