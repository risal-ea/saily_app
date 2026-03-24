import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';

/// Animated floating pill-style bottom navigation bar.
/// Uses [HomeViewModel.selectedTabIndex] for state and
/// [HomeViewModel.selectTab] for tab switching (no setState).
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.vm});

  final HomeViewModel vm;

  static const List<({IconData icon, String label})> _tabs = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.account_balance_wallet_outlined, label: 'Credits'),
    (icon: Icons.contact_support_outlined, label: 'Help'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tabWidth = constraints.maxWidth / _tabs.length;
          return Stack(
            children: [
              // Sliding pill highlight
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: tabWidth * vm.selectedTabIndex,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Tab items
              Row(
                children: List.generate(
                  _tabs.length,
                  (i) => _NavItem(
                    index: i,
                    icon: _tabs[i].icon,
                    label: _tabs[i].label,
                    width: tabWidth,
                    isSelected: vm.selectedTabIndex == i,
                    onTap: () => context.read<HomeViewModel>().selectTab(i),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.width,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String label;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF1A1A1A), size: 26),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
