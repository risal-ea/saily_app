/// Represents the current state of the user's security protections.
/// Plain Dart model class following MVVM guidelines.
class SecurityStateModel {
  bool isVpnEnabled;
  bool isAdBlockerEnabled;
  bool isWebProtectionEnabled;
  int trackersBlockedToday;

  SecurityStateModel({
    this.isVpnEnabled = false,
    this.isAdBlockerEnabled = false,
    this.isWebProtectionEnabled = false,
    this.trackersBlockedToday = 0,
  });

  /// Helper getter to determine if the user is fully protected.
  /// If any core protection is disabled, the user is considered "At Risk".
  bool get isFullyProtected =>
      isVpnEnabled && isAdBlockerEnabled && isWebProtectionEnabled;

  /// Optional: Factory for JSON deserialization (ready for API integration)
  factory SecurityStateModel.fromJson(Map<String, dynamic> json) {
    return SecurityStateModel(
      isVpnEnabled: json['isVpnEnabled'] ?? false,
      isAdBlockerEnabled: json['isAdBlockerEnabled'] ?? false,
      isWebProtectionEnabled: json['isWebProtectionEnabled'] ?? false,
      trackersBlockedToday: json['trackersBlockedToday'] ?? 0,
    );
  }

  /// Optional: Method for JSON serialization (ready for API integration)
  Map<String, dynamic> toJson() {
    return {
      'isVpnEnabled': isVpnEnabled,
      'isAdBlockerEnabled': isAdBlockerEnabled,
      'isWebProtectionEnabled': isWebProtectionEnabled,
      'trackersBlockedToday': trackersBlockedToday,
    };
  }
}
