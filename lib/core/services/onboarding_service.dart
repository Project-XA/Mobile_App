import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  final SharedPreferences _prefs;
  
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyUserRole = 'user_role';
  static const String _keyIsLoggedIn = 'is_logged_in';

  OnboardingService(this._prefs);

  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(_keyHasCompletedOnboarding) ?? false;
  }

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// [userRole] should be 'Admin' or 'User'
  Future<void> markOnboardingComplete(String userRole) async {
    await _prefs.setBool(_keyHasCompletedOnboarding, true);
    await _prefs.setString(_keyUserRole, userRole);
    await _prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<String?> getUserRole() async {
    return _prefs.getString(_keyUserRole);
  }

  Future<void> clearOnboardingState() async {
    await _prefs.remove(_keyHasCompletedOnboarding);
    await _prefs.remove(_keyUserRole);
    await _prefs.remove(_keyIsLoggedIn);
  }

  Future<void> logout() async {
    await DioFactory.clearTokens();
    
    await _prefs.remove(_keyIsLoggedIn);
  }
}