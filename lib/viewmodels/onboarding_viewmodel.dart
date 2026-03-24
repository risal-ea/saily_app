import 'package:flutter/foundation.dart';
import 'package:saily_app/data/services/storage_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  final StorageService _storageService;

  OnboardingViewModel(this._storageService);

  // ---------- State ----------
  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == 2;

  // ---------- Actions ----------
  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingSeen();
  }
}
