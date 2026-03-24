import 'dart:convert';
import 'package:saily_app/data/models/data_plan_model.dart';
import 'package:saily_app/data/models/esim_model.dart';
import 'package:saily_app/data/services/storage_service.dart';

/// Repository responsible for providing Home Screen data.
/// It abstracts the StorageService for offline persistence.
class HomeRepository {
  final StorageService _storageService;

  HomeRepository(this._storageService);

  // ---------- Core Fetching ----------

  /// Fetches physically stored eSIMs off the device
  Future<List<ESimModel>> getEsims() async {
    final rawStrings = _storageService.getPurchasedEsims();
    return rawStrings
        .map((str) => ESimModel.fromJson(jsonDecode(str) as Map<String, dynamic>))
        .toList();
  }

  /// Finds and returns the actively tracked eSIM (defaults to newest if none flagged)
  Future<ESimModel?> getActiveEsim() async {
    final esims = await getEsims();
    if (esims.isEmpty) return null;

    final activeId = _storageService.getActiveEsimId();
    if (activeId == null) return esims.first;

    try {
      return esims.firstWhere((e) => e.id == activeId);
    } catch (_) {
      return esims.first; // Fallback
    }
  }

  // ---------- Modification Triggers ----------

  /// Commits the array back to disk with the changed element.
  Future<void> _updateEsims(List<ESimModel> esims) async {
    final rawStrings = esims.map((e) => jsonEncode(e.toJson())).toList();
    await _storageService.setPurchasedEsims(rawStrings);
  }

  /// Completes a real purchase from the store by bridging the store model
  /// into an active state model tracking usage.
  Future<void> purchaseEsim(DataPlanModel plan, double initialDataGb) async {
    final esims = await getEsims();
    final newId = 'esim_${DateTime.now().millisecondsSinceEpoch}';

    final isRegional = plan.category == PlanCategory.regional;
    final newEsim = ESimModel(
      id: newId,
      title: isRegional ? 'Travel Pass' : 'eSIM',
      subtitle: plan.name,
      status: ESimStatus.active,
      coverage: isRegional ? ESimCoverage.regional : ESimCoverage.country,
      flag: plan.flag,
      gradientColors: isRegional 
          ? [0xFF059669, 0xFF10B981] 
          : [0xFF7C3AED, 0xFF9333EA],
      iconCodePoint: isRegional ? 0xe894 : 0xe521,
      dataTotalGb: initialDataGb,
      dataUsedGb: 0.0,
    );

    esims.insert(0, newEsim); // Latest first
    await _updateEsims(esims);
    await setActiveEsim(newId);
  }

  /// Appends bought data to an existing eSIM card pointer
  Future<void> topUpEsim(String id, double dataGb) async {
    final esims = await getEsims();
    final index = esims.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final current = esims[index];
    esims[index] = current.copyWith(
      dataTotalGb: current.dataTotalGb + dataGb,
      status: ESimStatus.active, // Reactivate if it was expired
    );

    await _updateEsims(esims);
  }

  Future<void> setActiveEsim(String id) async {
    await _storageService.setActiveEsimId(id);
  }

  // ---------- Telemetry/Burn Triggers ----------

  /// A mock system interval that burns 500MB on all active eSIMs for 
  /// demonstrating the high-fidelity UI tracking features.
  Future<void> simulateDataUsage(double gbToBurn) async {
    final esims = await getEsims();
    bool changed = false;

    for (int i = 0; i < esims.length; i++) {
      final sim = esims[i];
      if (sim.isActive && sim.dataTotalGb > 0 && !sim.isExpired) {
        final newUsed = (sim.dataUsedGb + gbToBurn).clamp(0.0, sim.dataTotalGb);
        if (newUsed != sim.dataUsedGb) {
          esims[i] = sim.copyWith(dataUsedGb: newUsed);
          changed = true;
        }
      }
    }

    if (changed) {
      await _updateEsims(esims);
    }
  }
}
