import 'package:flutter/foundation.dart';
import 'package:saily_app/data/models/esim_model.dart';

import 'package:saily_app/viewmodels/home_viewmodel.dart';

/// ViewModel for managing the state of an individual eSIM on the details page.
class EsimDetailsViewModel extends ChangeNotifier {
  EsimDetailsViewModel(this._esim, this._homeVm);

  final ESimModel _esim;
  final HomeViewModel _homeVm;

  // Read-only access to the underlying model properties
  ESimModel get esim => _esim;

  bool get isActiveEsim => _homeVm.activeEsim?.id == _esim.id;

  // --- Mutable View State (Mocked) ---
  
  bool _isDataRoamingEnabled = false;
  bool get isDataRoamingEnabled => _isDataRoamingEnabled;

  bool _isAutoRenewEnabled = true;
  bool get isAutoRenewEnabled => _isAutoRenewEnabled;

  // --- Actions ---

  Future<void> toggleActiveEsim(bool value) async {
    if (value && !isActiveEsim) {
      await _homeVm.setActiveEsim(_esim.id);
      notifyListeners();
    }
  }

  void toggleDataRoaming(bool value) {
    _isDataRoamingEnabled = value;
    notifyListeners();
    // TODO: Call API/Service to save this preference
  }

  void toggleAutoRenew(bool value) {
    _isAutoRenewEnabled = value;
    notifyListeners();
    // TODO: Call API/Service to save this preference
  }

  /// Example action: Rename the eSIM
  Future<void> renameEsim(String newName) async {
    // In a real app, you'd call a repository here and then update the model.
    // _esim = _esim.copyWith(title: newName);
    // notifyListeners();
  }

  /// Example action: Delete/Uninstall the eSIM
  Future<void> uninstallEsim() async {
    // Call repository to remove
  }
}
