import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/data/models/esim_model.dart';
import 'package:saily_app/views/esim_details/esim_details_screen.dart';

class AllEsimsScreen extends StatelessWidget {
  const AllEsimsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.homeBackground,
            elevation: 0,
            pinned: true,
            expandedHeight: 120,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: const Text(
                'Your eSIMs',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontWeight: FontWeight.w900,
                  color: AppColors.textBlack,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: false,
            ),
          ),
          Consumer<HomeViewModel>(
            builder: (context, vm, _) {
              if (vm.eSims.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No eSIMs found.",
                      style: TextStyle(fontFamily: 'Fustat', color: AppColors.textGrey, fontSize: 16),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final esim = vm.eSims[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _PremiumWalletCard(esim: esim),
                      );
                    },
                    childCount: vm.eSims.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PremiumWalletCard extends StatelessWidget {
  final ESimModel esim;

  const _PremiumWalletCard({required this.esim});

  @override
  Widget build(BuildContext context) {
    final gradientColors = esim.gradientColors.map((c) => Color(c)).toList();
    final remaining = (esim.dataTotalGb - esim.dataUsedGb).clamp(0.0, esim.dataTotalGb);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EsimDetailsScreen(esim: esim),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Background abstract SIM graphic
              Positioned(
                right: -40,
                bottom: -40,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Icon(
                    Icons.sim_card,
                    size: 200,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),
              
              // Top Section (Country & Status)
              Positioned(
                top: 24,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: esim.flag != null
                              ? Text(esim.flag!, style: const TextStyle(fontSize: 20))
                              : Icon(
                                  IconData(esim.iconCodePoint, fontFamily: 'MaterialIcons'),
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          esim.title.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Fustat',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        esim.isExpired ? 'EXPIRED' : (esim.isActive ? 'ACTIVE PLAN' : 'READY'),
                        style: TextStyle(
                          fontFamily: 'Fustat',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: esim.isExpired ? const Color(0xFFFFB4AB) : Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Glassmorphism Section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 70,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AVAILABLE DATA',
                                style: TextStyle(
                                  fontFamily: 'Fustat',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    remaining.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontFamily: 'Fustat',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'GB / ${esim.dataTotalGb.toStringAsFixed(0)} GB',
                                    style: const TextStyle(
                                      fontFamily: 'Fustat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
