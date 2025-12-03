import 'onboarding_local_service.dart';
import 'onboarding_remote_service.dart';

class OnboardingRepo {
  final OnboardingLocalService _localService;
  final OnboardingRemoteService _remoteService;

  OnboardingRepo({
    OnboardingLocalService? localService,
    OnboardingRemoteService? remoteService,
  }) : _localService = localService ?? OnboardingLocalService(),
       _remoteService = remoteService ?? OnboardingRemoteService();

  Future<void> init() async {
    await _localService.init();
  }

  // Generate (Remote -> Local)
  Future<Map<String, dynamic>> generateStrategy(
    Map<String, dynamic> userProfile,
  ) async {
    try {
      final remoteData = await _remoteService.generateStrategy(userProfile);
      await _localService.saveStrategy(remoteData);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }

  // Save Progress (Local Update)
  Future<void> saveStrategyProgress(
    Map<String, dynamic> updatedStrategy,
  ) async {
    await _localService.updateStrategy(updatedStrategy);
  }

  // Get Active
  Map<String, dynamic>? getActiveStrategy() {
    return _localService.getStrategy();
  }

  Future<void> resetStrategy() async {
    await _localService.clearStrategy();
  }
}
