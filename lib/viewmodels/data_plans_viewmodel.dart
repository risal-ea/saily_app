import 'package:flutter/foundation.dart';
import 'package:saily_app/data/models/data_plan_model.dart';

class DataPlansViewModel extends ChangeNotifier {
  // ---------- State ----------

  PlanCategory _selectedCategory = PlanCategory.country;
  PlanCategory get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ---------- Data Accessors ----------

  List<DataPlanModel> get topPicks {
    return _allPlans
        .where((plan) =>
            plan.category == PlanCategory.country &&
            plan.isTopPick &&
            plan.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<DataPlanModel> get allDestinations {
    return _allPlans
        .where((plan) =>
            plan.category == PlanCategory.country &&
            !plan.isTopPick &&
            plan.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<DataPlanModel> get regionalPlans {
    return _allPlans
        .where((plan) =>
            plan.category == PlanCategory.regional &&
            plan.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // ---------- Actions ----------

  void selectCategory(PlanCategory category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ---------- Mock Data ----------

  final List<DataPlanModel> _allPlans = const [
    // Top Picks (Country)
    DataPlanModel(
      id: 'us',
      name: 'United States',
      flag: '🇺🇸',
      startingPrice: 3.99,
      description: 'USA coverage',
      category: PlanCategory.country,
      isTopPick: true,
    ),
    DataPlanModel(
      id: 'jp',
      name: 'Japan',
      flag: '🇯🇵',
      startingPrice: 3.99,
      description: 'Japan coverage',
      category: PlanCategory.country,
      isTopPick: true,
    ),
    DataPlanModel(
      id: 'uk',
      name: 'United Kingdom',
      flag: '🇬🇧',
      startingPrice: 4.49,
      description: 'UK coverage',
      category: PlanCategory.country,
      isTopPick: true,
    ),
    DataPlanModel(
      id: 'ca',
      name: 'Canada',
      flag: '🇨🇦',
      startingPrice: 5.29,
      description: 'Canada coverage',
      category: PlanCategory.country,
      isTopPick: true,
    ),
    DataPlanModel(
      id: 'tr',
      name: 'Turkey',
      flag: '🇹🇷',
      startingPrice: 3.99,
      description: 'Turkey coverage',
      category: PlanCategory.country,
      isTopPick: true,
    ),

    // All Destinations (Country)
    DataPlanModel(
      id: 'af',
      name: 'Afghanistan',
      flag: '🇦🇫',
      startingPrice: 5.49,
      description: 'Afghanistan coverage',
      category: PlanCategory.country,
    ),
    DataPlanModel(
      id: 'al',
      name: 'Albania',
      flag: '🇦🇱',
      startingPrice: 4.99,
      description: 'Albania coverage',
      category: PlanCategory.country,
    ),
    DataPlanModel(
      id: 'in',
      name: 'India',
      flag: '🇮🇳',
      startingPrice: 3.99,
      description: 'India coverage',
      category: PlanCategory.country,
    ),

    // Regional
    DataPlanModel(
      id: 'reg_global',
      name: 'Global',
      flag: '🌎',
      startingPrice: 8.99,
      description: '121 countries',
      category: PlanCategory.regional,
    ),
    DataPlanModel(
      id: 'reg_europe',
      name: 'Europe',
      flag: '🌍',
      startingPrice: 4.99,
      description: '35 countries',
      category: PlanCategory.regional,
    ),
    DataPlanModel(
      id: 'reg_asia',
      name: 'Asia and Oceania',
      flag: '🌏',
      startingPrice: 4.99,
      description: '19 countries',
      category: PlanCategory.regional,
    ),
    DataPlanModel(
      id: 'reg_na',
      name: 'North America',
      flag: '🌎',
      startingPrice: 5.99,
      description: '2 countries',
      category: PlanCategory.regional,
    ),
    DataPlanModel(
      id: 'reg_mena',
      name: 'Middle East and North Africa',
      flag: '🌍',
      startingPrice: 7.49,
      description: '19 countries',
      category: PlanCategory.regional,
    ),
  ];
}
