// file: lib/viewmodels/home_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:saily_app/data/models/esim_model.dart';
import 'package:saily_app/data/models/for_you_card_model.dart';
import 'package:saily_app/data/models/security_state_model.dart';

class HomeViewModel extends ChangeNotifier {
  // ---------- State ----------
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // eSIM cards displayed in "Your eSIMs" carousel
  List<ESimModel> _eSims = [];
  List<ESimModel> get eSims => List.unmodifiable(_eSims);

  // Smart recommendation cards for "For You" section (max 3 shown)
  List<ForYouCardModel> _forYouCards = [];
  List<ForYouCardModel> get forYouCards => List.unmodifiable(_forYouCards);

  // Home screen header data
  // ignore: prefer_final_fields
  String _countryName = 'United States';
  String get countryName => _countryName;

  // ignore: prefer_final_fields
  String _countryFlag = '🇺🇸';
  String get countryFlag => _countryFlag;

  // ignore: prefer_final_fields
  double _dataUsedGb = 1.2;
  double get dataUsedGb => _dataUsedGb;

  // ignore: prefer_final_fields
  double _dataTotalGb = 5.0;
  double get dataTotalGb => _dataTotalGb;

  double get dataUsagePercent =>
      _dataTotalGb > 0 ? (_dataUsedGb / _dataTotalGb).clamp(0.0, 1.0) : 0.0;

  String get dataUsedLabel => '${_dataUsedGb.toStringAsFixed(1)} GB';
  String get dataRemainingLabel =>
      '${(_dataTotalGb - _dataUsedGb).clamp(0, _dataTotalGb).toStringAsFixed(1)} GB left';

  HomeViewModel() {
    _loadMockData();
  }

  // ---------- Actions ----------

  void selectTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    notifyListeners();
  }

  /// Refreshes home screen data (calls repository in production).
  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: replace with real repository calls
      await Future.delayed(const Duration(milliseconds: 300));
      _loadMockData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------- Security State ----------

  final SecurityStateModel _securityState = SecurityStateModel(
    isVpnEnabled: false,
    isAdBlockerEnabled: true,
    isWebProtectionEnabled: true,
    trackersBlockedToday: 23,
  );

  SecurityStateModel get securityState => _securityState;

  void toggleVpn(bool value) {
    _securityState.isVpnEnabled = value;
    notifyListeners();
  }

  void toggleAdBlocker(bool value) {
    _securityState.isAdBlockerEnabled = value;
    if (!value) _securityState.trackersBlockedToday = 0;
    notifyListeners();
  }

  void toggleWebProtection(bool value) {
    _securityState.isWebProtectionEnabled = value;
    notifyListeners();
  }

  // ---------- Private Helpers ----------

  /// Loads static mock data. Replace with repository calls when backend is ready.
  void _loadMockData() {
    _eSims = _buildMockESims();
    _forYouCards = _buildForYouCards();
  }

  List<ESimModel> _buildMockESims() {
    return [
      const ESimModel(
        id: 'esim_india',
        title: 'Main eSIM',
        subtitle: 'India',
        status: ESimStatus.active,
        coverage: ESimCoverage.country,
        flag: '🇮🇳',
        gradientColors: [0xFF7C3AED, 0xFF9333EA],
        iconCodePoint: 0xe521, // Icons.sim_card
      ),
      const ESimModel(
        id: 'esim_global',
        title: 'Travel Pack',
        subtitle: 'Global',
        status: ESimStatus.active,
        coverage: ESimCoverage.regional,
        gradientColors: [0xFF059669, 0xFF10B981],
        iconCodePoint: 0xe894, // Icons.language
      ),
      const ESimModel(
        id: 'esim_europe',
        title: 'Europe',
        subtitle: 'Regional',
        status: ESimStatus.expired,
        coverage: ESimCoverage.regional,
        gradientColors: [0xFFDC2626, 0xFFF87171],
        iconCodePoint: 0xe539, // Icons.flight_takeoff
      ),
    ];
  }

  /// Business logic: builds priority-ordered "For You" cards based on user state.
  /// Max 3 cards are returned, ordered by priority.
  List<ForYouCardModel> _buildForYouCards() {
    final cards = <ForYouCardModel>[];

    // Priority 1: Location-based activation (show if user is detected in a new country)
    cards.add(const ForYouCardModel(
      id: 'card_location_uae',
      type: ForYouCardType.locationActivation,
      title: "You're in UAE",
      subtitle: "Activate your UAE eSIM",
      ctaText: "Activate",
      flag: "🇦🇪",
      isHighlighted: true,
    ));

    // Priority 2: Data usage warning (show if usage > 70%)
    if (dataUsagePercent >= 0.7) {
      cards.add(ForYouCardModel(
        id: 'card_low_data',
        type: ForYouCardType.dataUsageWarning,
        title: "Low Data",
        subtitle: "You've used ${(dataUsagePercent * 100).round()}% of your data",
        ctaText: "Top Up",
        progress: dataUsagePercent,
        iconCodePoint: 0xe1a5, // Icons.data_usage_rounded
      ));
    }

    // Priority 3: Expiry reminder (show if any plan expires in < 3 days)
    final expiringSoon = _eSims.where((e) => e.isActive).isEmpty;
    if (expiringSoon) {
      cards.add(const ForYouCardModel(
        id: 'card_expiry',
        type: ForYouCardType.expiryReminder,
        title: "Plan Expiring Soon",
        subtitle: "Your plan expires in 1 day",
        ctaText: "Extend",
        iconCodePoint: 0xe855, // Icons.schedule
      ));
    }

    // Priority 4: Offers / Quick Buy
    if (cards.length < 3) {
      cards.add(const ForYouCardModel(
        id: 'offer_weekend_data',
        type: ForYouCardType.quickBuy,
        title: "Weekend Special",
        subtitle: "Get 5GB for \$5 this weekend only",
        ctaText: "Get Offer",
        iconCodePoint: 0xf0201, // Icons.local_offer_outlined
      ));
    }

    if (cards.length < 3) {
      cards.add(const ForYouCardModel(
        id: 'offer_asia_pass',
        type: ForYouCardType.quickBuy,
        title: "Going to Asia?",
        subtitle: "20% off all Asia Regional passes",
        ctaText: "Claim",
        iconCodePoint: 0xe539, // Icons.flight_takeoff
        isHighlighted: true,
      ));
    }

    // Return max 3 cards
    return cards.take(3).toList();
  }
}
