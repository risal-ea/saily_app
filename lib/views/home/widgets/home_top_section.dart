import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/views/data_plans/data_plans_screen.dart';
import 'package:saily_app/views/home/widgets/quick_buy_bottom_sheet.dart';

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
              if (vm.eSims.isNotEmpty) ...[
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
                _planCardsRow(context),
                const SizedBox(height: 24),
              ],
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DataPlansScreen(),
                    ),
                  );
                },
                child: CustomPaint(
                  painter: _DashedBorderPainter(
                    color: Colors.white,
                    strokeWidth: 1.5,
                    radius: 16.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Explore Plans',
                        style: TextStyle(
                          fontFamily: 'Fustat',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
    if (vm.eSims.isEmpty) {
      return const Row(
        children: [
          Text('👋', style: TextStyle(fontSize: 24)),
          SizedBox(width: 10),
          Text(
            'Ready to travel?',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

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
    if (vm.eSims.isEmpty) {
      return const Text(
        'No active plan',
        style: TextStyle(
          fontFamily: 'Fustat',
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -1,
        ),
      );
    }

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

  Widget _planCardsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _planCard(context, '2 GB', '\$3.5', 2.0),
        _planCard(context, '6 GB', '\$8', 6.0),
        _planCard(context, '1 GB', '\$2', 1.0),
        _viewAllCard(context),
      ],
    );
  }

  Widget _planCard(BuildContext context, String data, String price, double gigabytes) {
    return GestureDetector(
      onTap: () {
        if (vm.activeEsim == null) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => QuickBuyBottomSheet(
            activeEsim: vm.activeEsim!,
            dataLabel: data,
            priceLabel: price,
            gigabytes: gigabytes,
          ),
        );
      },
      child: Container(
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
      ),
    );
  }

  Widget _viewAllCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DataPlansScreen(),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.radius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius)));

    PathMetrics pathMetrics = path.computeMetrics();
    Path dashedPath = Path();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        double len = draw ? 6.0 : 4.0; // dashLength : gapLength
        dashedPath.addPath(
            pathMetric.extractPath(distance, distance + len), Offset.zero);
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
