import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/data/models/data_plan_model.dart';
import 'package:saily_app/viewmodels/data_plans_viewmodel.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';

class DataPlansScreen extends StatelessWidget {
  const DataPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataPlansViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        appBar: AppBar(
          backgroundColor: AppColors.homeBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textBlack),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Data plans',
            style: TextStyle(
              fontFamily: 'Fustat',
              color: AppColors.textBlack,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: const Stack(
          children: [
            _DataPlansBody(),
            _FloatingSearch(),
          ],
        ),
      ),
    );
  }
}

class _DataPlansBody extends StatelessWidget {
  const _DataPlansBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DataPlansViewModel>();

    return Column(
      children: [
        _buildFilterChips(vm),
        Expanded(
          child: CustomScrollView(
            slivers: [
              if (vm.selectedCategory == PlanCategory.country) ...[
                if (vm.topPicks.isNotEmpty) ...[
                  _buildSectionHeader('Top picks'),
                  _buildPlanList(vm.topPicks),
                ],
                _buildSectionHeader('All destinations'),
                _buildPlanList(vm.allDestinations),
              ] else if (vm.selectedCategory == PlanCategory.regional) ...[
                _buildSectionHeader('Regional'),
                _buildPlanList(vm.regionalPlans),
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // padding for floating search
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(DataPlansViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FilterChip(
            label: 'Country',
            isSelected: vm.selectedCategory == PlanCategory.country,
            onTap: () => vm.selectCategory(PlanCategory.country),
          ),
          const SizedBox(width: 12),
          _FilterChip(
            label: 'Regional',
            isSelected: vm.selectedCategory == PlanCategory.regional,
            onTap: () => vm.selectCategory(PlanCategory.regional),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Fustat',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanList(List<DataPlanModel> plans) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final plan = plans[index];
            final isFirst = index == 0;
            final isLast = index == plans.length - 1;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isFirst ? 16 : 0),
                  bottom: Radius.circular(isLast ? 16 : 0),
                ),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: ListTile(
                onTap: () {
                  final homeVm = context.read<HomeViewModel>();
                  homeVm.purchaseNewEsim(plan, plan.startingPrice <= 5.0 ? 3.0 : 10.0);
                  Navigator.pop(context);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.homeBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(plan.flag, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                title: Text(
                  plan.name,
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${plan.formattedPrice} • ${plan.description}',
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ),
            );
          },
          childCount: plans.length,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD500) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Fustat',
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 15,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}

class _FloatingSearch extends StatelessWidget {
  const _FloatingSearch();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DataPlansViewModel>();

    return Positioned(
      left: 24,
      right: 24,
      bottom: 32, // Safely above home indicator usually
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextField(
          onChanged: vm.updateSearchQuery,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              fontFamily: 'Fustat',
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.textBlack),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}
