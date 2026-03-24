import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';

/// Gradient header card showing country, data usage, progress bar, and plan buttons.
class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // Purple gradient (original)
          colors: [AppColors.homeGradientStart, AppColors.homeGradientEnd],
          // Yellow / warm gradient
          // colors: [Color(0xFFFFB800), Color(0xFFFF8C00)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 32),
              _countryRow(),
              const SizedBox(height: 12),
              _dataUsageRow(),
              const SizedBox(height: 16),
              _progressBar(),
              const SizedBox(height: 32),
              const Text(
                'Select & get add-on data',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _planCardsRow(),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/logo.png', height: 28, color: Colors.white),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.iconBackground,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _countryRow() {
    return Row(
      children: [
        Text(vm.countryFlag, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Text(
          vm.countryName,
          style: const TextStyle(
            fontFamily: 'Fustat',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
      ],
    );
  }

  Widget _dataUsageRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          vm.dataUsedLabel,
          style: const TextStyle(
            fontFamily: 'Fustat',
            fontSize: 42,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          vm.dataRemainingLabel,
          style: const TextStyle(
            fontFamily: 'Fustat',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _progressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: vm.dataUsagePercent,
        minHeight: 8,
        backgroundColor: Colors.white.withValues(alpha: 0.3),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _planCardsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _planCard('2 GB', '\$3.5'),
        _planCard('6 GB', '\$8'),
        _planCard('1 GB', '\$2'),
        _viewAllCard(),
      ],
    );
  }

  Widget _planCard(String data, String price) {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data,
            style: const TextStyle(
              fontFamily: 'Fustat',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.homeGradientStart,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Fustat',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.homeGradientStart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewAllCard() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.iconBackground,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, size: 20, color: Colors.white),
          SizedBox(height: 3),
          Text(
            'View all',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
