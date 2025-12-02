import 'onboarding_local_service.dart';
import 'onboarding_remote_service.dart';

class OnboardingRepo {
  final OnboardingLocalService _localService;
  final OnboardingRemoteService _remoteService;

  // Dependency Injection via constructor (optional, can simulate here)
  OnboardingRepo({
    OnboardingLocalService? localService,
    OnboardingRemoteService? remoteService,
  }) : _localService = localService ?? OnboardingLocalService(),
       _remoteService = remoteService ?? OnboardingRemoteService();

  // Initialization
  Future<void> init() async {
    await _localService.init();
  }

  // The Main Strategy Flow: Remote -> Local -> Return
  Future<Map<String, dynamic>> generateStrategy(
    Map<String, dynamic> userProfile,
  ) async {
    try {
      // 1. Fetch from API
      final remoteData = await _remoteService.generateStrategy(userProfile);

      // 2. Cache Locally (Offline-First)
      await _localService.saveStrategy(remoteData);

      return remoteData;
    } catch (e) {
      // Error handling strategy:
      // If we had a previously saved strategy, we could return it here as a fallback?
      // For Onboarding, we usually want fresh data, so we rethrow.
      print("Repo Error: $e");
      rethrow;
    }
  }

  // Accessors for UI
  Map<String, dynamic>? getActiveStrategy() {
    return _localService.getStrategy();
  }

  Future<void> resetStrategy() async {
    await _localService.clearStrategy();
  }
}
