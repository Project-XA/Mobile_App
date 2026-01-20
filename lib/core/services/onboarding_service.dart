import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:mobile_app/core/services/auth_state_service.dart';

class OnboardingService {
  final AuthStateService _authStateService;
  final UserLocalDataSource _userLocalDataSource;

  OnboardingService(
    this._authStateService,
    this._userLocalDataSource,
  );

  // ========== OCR Related ==========
  Future<bool> hasCompletedOCR() async {
    return await _authStateService.hasCompletedOCR();
  }

  Future<void> markOCRComplete() async {
    await _authStateService.markOCRComplete();
  }

  // ========== Registration Related ==========
  Future<bool> hasCompletedOnboarding() async {
    return await _authStateService.hasRegistered();
  }

  Future<void> markOnboardingComplete(String userRole) async {
    await _authStateService.markRegistrationComplete(userRole);
  }

  // ========== Login/Logout Related (Token-based) ==========
  
  /// Check if user is logged in (has valid token in Hive)
  Future<bool> isLoggedIn() async {
    // Check both: AuthState flag AND actual token in UserModel
    final authStateLoggedIn = await _authStateService.isLoggedIn();
    
    if (!authStateLoggedIn) return false;
    
    // Double-check token exists in user data
    try {
      final hasToken = await _userLocalDataSource.hasValidToken();
      return hasToken;
    } catch (e) {
      return false;
    }
  }

  /// Logout user - clears token from both Dio and Hive
  Future<void> logout() async {
    // 1. Clear token from Dio interceptor
    await DioFactory.clearTokens();
    
    // 2. Clear token from user data in Hive
    await _userLocalDataSource.logout();
    
    // 3. Update auth state
    await _authStateService.clearAuthState();
  }

  Future<void> markLoggedIn(String userRole) async {
    await _authStateService.markLoggedIn(userRole);
  }

  Future<String?> getUserRole() async {
    return await _authStateService.getUserRole();
  }

  Future<void> clearOnboardingState() async {
    await _authStateService.clearAll();
  }
}