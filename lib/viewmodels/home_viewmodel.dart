import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:saily_app/data/models/data_plan_model.dart';
import 'package:saily_app/data/models/esim_model.dart';
import 'package:saily_app/data/models/for_you_card_model.dart';
import 'package:saily_app/data/models/security_state_model.dart';
import 'package:saily_app/data/repositories/home_repository.dart';
import 'package:saily_app/data/services/storage_service.dart';

class HomeViewModel extends ChangeNotifier {
  late final HomeRepository _repository;
  Timer? _dataBurnTimer;

  HomeViewModel(StorageService storageService) {
    _repository = HomeRepository(storageService);
    refresh();

    // Automatically reduce 500MB (0.5GB) every 5 seconds for demonstration purposes
    _dataBurnTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _simulateDataBurn(),
    );
  }

  @override
  void dispose() {
    _dataBurnTimer?.cancel();
    super.dispose();
  }

  // ---------- State ----------
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ESimModel> _eSims = [];
  List<ESimModel> get eSims => List.unmodifiable(_eSims);

  ESimModel? _activeEsim;
  ESimModel? get activeEsim => _activeEsim;

  List<ForYouCardModel> _forYouCards = [];
  List<ForYouCardModel> get forYouCards => List.unmodifiable(_forYouCards);

  // ---------- Dynamic Header Helpers based on Active eSIM ----------

  String get countryName => _activeEsim?.subtitle ?? 'No Region';

  String get countryFlag => _activeEsim?.flag ?? '🌎';

  double get dataTotalGb => _activeEsim?.dataTotalGb ?? 0.0;

  double get dataUsedGb => _activeEsim?.dataUsedGb ?? 0.0;

  double get dataUsagePercent => _activeEsim?.dataUsagePercent ?? 0.0;

  String get dataUsedLabel {
    final remaining = (dataTotalGb - dataUsedGb).clamp(0.0, dataTotalGb);
    return '${remaining.toStringAsFixed(1)} GB';
  }

  String get dataRemainingLabel => 'of ${dataTotalGb.toStringAsFixed(1)} GB';

  // ---------- Actions ----------

  void selectTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    notifyListeners();
  }

  /// Top-up data for the *active* eSIM map (e.g. from the 2GB, 6GB quick bubbles)
  Future<void> buyDataPlan(double gigabytes) async {
    if (_activeEsim == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.topUpEsim(_activeEsim!.id, gigabytes);
      await _loadData();
    } catch (e) {
      _errorMessage = 'Failed to top-up data: $e';
      notifyListeners();
    }
  }

  /// Purchases a totally new data plan block from the store
  Future<void> purchaseNewEsim(DataPlanModel plan, double initialDataGb) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.purchaseEsim(plan, initialDataGb);
      await _loadData();
    } catch (e) {
      _errorMessage = 'Purchase failed: $e';
      notifyListeners();
    }
  }

  Future<void> setActiveEsim(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.setActiveEsim(id);
      await _loadData();
    } catch (e) {
      _errorMessage = 'Failed to activate plan: $e';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadData();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _simulateDataBurn() async {
    if (_eSims.isEmpty) return;
    await _repository.simulateDataUsage(0.5); // 500MB burn
    await _loadData(); // Pull down the new burned stats securely
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
    notifyListeners();
  }

  void toggleWebProtection(bool value) {
    _securityState.isWebProtectionEnabled = value;
    notifyListeners();
  }

  // ---------- Private Core Logic ----------

  Future<void> _loadData() async {
    _eSims = await _repository.getEsims();
    _activeEsim = await _repository.getActiveEsim();
    _forYouCards = _buildForYouCards();

    _isLoading = false;
    notifyListeners();
  }

  List<ForYouCardModel> _buildForYouCards() {
    final cards = <ForYouCardModel>[];

    if (_eSims.isEmpty) {
      cards.add(
        const ForYouCardModel(
          id: 'card_welcome',
          type: ForYouCardType.quickBuy,
          title: "Welcome to Saily!",
          subtitle: "Select a plan above to get started",
          ctaText: "Shop Plans",
          iconCodePoint: 0xe8cc,
          isHighlighted: true,
        ),
      );
      return cards;
    }

    // Priority 1: Data usage warning (show if remaining <= 30%)
    if (dataUsagePercent <= 0.3) {
      cards.add(
        ForYouCardModel(
          id: 'card_low_data',
          type: ForYouCardType.dataUsageWarning,
          title: "Low Data",
          subtitle:
              "You only have ${(dataUsagePercent * 100).round()}% of your active plan remaining",
          ctaText: "Top Up",
          progress: dataUsagePercent,
          iconCodePoint: 0xe1a5,
        ),
      );
    }

    if (cards.length < 3) {
      cards.add(
        const ForYouCardModel(
          id: 'offer_weekend_data',
          type: ForYouCardType.quickBuy,
          title: "Weekend Special",
          subtitle: "Get 5GB for \$5",
          ctaText: "Get Offer",
          iconCodePoint: 0xf0201,
        ),
      );
    }

    if (cards.length < 3) {
      cards.add(
        const ForYouCardModel(
          id: 'offer_asia_pass',
          type: ForYouCardType.quickBuy,
          title: "Going to Asia?",
          subtitle: "20% off all Asia Regional passes",
          ctaText: "Claim",
          iconCodePoint: 0xe539,
          isHighlighted: true,
        ),
      );
    }

    return cards.take(3).toList();
  }
}
