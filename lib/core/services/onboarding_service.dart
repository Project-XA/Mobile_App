import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:mobile_app/core/services/auth_state_service.dart';

class OnboardingService {
  final AuthStateService _authStateService;
  
  OnboardingService(this._authStateService);

  Future<bool> hasCompletedOnboarding() async {
    return await _authStateService.hasRegistered();
  }

  Future<bool> hasCompletedOCR() async {
    return await _authStateService.hasCompletedOCR();
  }

  Future<bool> isLoggedIn() async {
    return await _authStateService.isLoggedIn();
  }

  Future<void> markOnboardingComplete(String userRole) async {
    await _authStateService.markRegistrationComplete(userRole);
  }

  Future<String?> getUserRole() async {
    return await _authStateService.getUserRole();
  }

  Future<void> clearOnboardingState() async {
    await _authStateService.clearAll();
  }

  Future<void> logout() async {
    await DioFactory.clearTokens();
    await _authStateService.clearAuthState();
  }
}