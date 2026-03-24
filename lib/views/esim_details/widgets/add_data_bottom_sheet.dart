import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/data/models/esim_model.dart';

class AddDataBottomSheet extends StatefulWidget {
  final ESimModel esim;

  const AddDataBottomSheet({super.key, required this.esim});

  @override
  State<AddDataBottomSheet> createState() => _AddDataBottomSheetState();
}

class _AddDataBottomSheetState extends State<AddDataBottomSheet> {
  int _selectedIndex = 1; // Default to the middle "6 GB" option

  final List<Map<String, dynamic>> _dataOptions = [
    {'gb': 2.0, 'label': '2 GB', 'price': '\$2', 'isBest': false},
    {'gb': 6.0, 'label': '6 GB', 'price': '\$5', 'isBest': true},
    {'gb': 1.0, 'label': '1 GB', 'price': '\$1', 'isBest': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Close button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF0F172A)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 8),

          // User info and Title
          const Text(
            'Hi, Saily User',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.esim.isExpired ? 'You are out of data!' : 'You are on low data!',
            style: const TextStyle(
              fontFamily: 'Fustat',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFFEF4444), // Red
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 48),

          // Packages selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_dataOptions.length, (index) {
              final option = _dataOptions[index];
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: _buildDataCard(
                  gbLabel: option['label'],
                  priceLabel: option['price'],
                  isBest: option['isBest'],
                  isSelected: isSelected,
                ),
              );
            }),
          ),

          const SizedBox(height: 48),

          // Buy Now Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                final amount = _dataOptions[_selectedIndex]['gb'] as double;
                final homeVm = context.read<HomeViewModel>();
                if (homeVm.activeEsim?.id != widget.esim.id) {
                    homeVm.setActiveEsim(widget.esim.id).then((_) {
                        homeVm.buyDataPlan(amount);
                    });
                } else {
                    homeVm.buyDataPlan(amount);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8), // Deep blue
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDataCard({
    required String gbLabel,
    required String priceLabel,
    required bool isBest,
    required bool isSelected,
  }) {
    // Colors mimicking the attached UI
    final borderColor = isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0);
    final bgColor = isSelected ? const Color(0xFFEEF2FF) : Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: isSelected ? 120 : 90,
          height: isSelected ? 110 : 90,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                gbLabel,
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: isSelected ? 28 : 20,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                priceLabel,
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: isSelected ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
        if (isBest)
          Positioned(
            top: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A), // Dark blue badge
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'BEST',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
