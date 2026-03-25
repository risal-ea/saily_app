import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/views/construction/construction_screen.dart';
import 'package:saily_app/views/home/widgets/esim_cards_section.dart';
import 'package:saily_app/views/home/widgets/floating_nav_bar.dart';
import 'package:saily_app/views/home/widgets/for_you_section.dart';
import 'package:saily_app/views/home/widgets/home_top_section.dart';
import 'package:saily_app/views/home/widgets/security_section.dart';

/// Entry point for the Home feature.
/// Pure View — no business logic or state.
/// All data comes from [HomeViewModel] via [Consumer].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) => Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: Stack(
          children: [
            // Tab pages — cross-fade between tabs
            Stack(
              children: [
                _fadingPage(vm, 0, _homeTab(context, vm)),
                _fadingPage(vm, 1, const ConstructionScreen(title: 'Credits')),
                _fadingPage(vm, 2, const ConstructionScreen(title: 'Help')),
                _fadingPage(vm, 3, const ConstructionScreen(title: 'Profile')),
              ],
            ),

            //TOP BLUR (Status bar area)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).padding.top + 8, // status bar height
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.1), // optional tint
                  ),
                ),
              ),
            ),

            // Floating nav bar overlaid at the bottom
            Positioned(
              bottom: 32,
              left: 20,
              right: 20,
              child: FloatingNavBar(vm: vm),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Wraps a page in a cross-fade animation keyed to [vm.selectedTabIndex].
  Widget _fadingPage(HomeViewModel vm, int index, Widget child) {
    final isActive = vm.selectedTabIndex == index;
    return IgnorePointer(
      ignoring: !isActive,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        opacity: isActive ? 1.0 : 0.0,
        child: child,
      ),
    );
  }

  /// Scrollable home tab content assembled from focused sub-widgets.
  Widget _homeTab(BuildContext context, HomeViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeTopSection(vm: vm),
          const SizedBox(height: 32),
          ESimCardsSection(vm: vm),
          const SizedBox(height: 32),
          ForYouSection(vm: vm),
          const SizedBox(height: 32),
          SecuritySection(vm: vm),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
