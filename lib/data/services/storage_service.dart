import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingKey = 'has_seen_onboarding';
  static const String _purchasedEsimsKey = 'purchased_esims';
  static const String _activeEsimIdKey = 'active_esim_id';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  bool hasSeenOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  List<String> getPurchasedEsims() {
    return _prefs.getStringList(_purchasedEsimsKey) ?? [];
  }

  Future<void> setPurchasedEsims(List<String> esims) async {
    await _prefs.setStringList(_purchasedEsimsKey, esims);
  }

  String? getActiveEsimId() {
    return _prefs.getString(_activeEsimIdKey);
  }

  Future<void> setActiveEsimId(String id) async {
    await _prefs.setString(_activeEsimIdKey, id);
  }

  /// Clears all stored data (useful for development/testing)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
