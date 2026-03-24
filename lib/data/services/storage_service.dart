import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingKey = 'has_seen_onboarding';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  bool hasSeenOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  /// Clears all stored data (useful for development/testing)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
