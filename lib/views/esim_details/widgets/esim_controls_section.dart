import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/esim_details_viewmodel.dart';
import 'package:saily_app/views/esim_details/widgets/add_data_bottom_sheet.dart';

/// Section containing toggle controls, secondary actions, and the primary Add Data CTA.
class EsimControlsSection extends StatelessWidget {
  const EsimControlsSection({super.key, required this.vm});

  final EsimDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Action: Add Data
        if (vm.esim.isActive)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(vm.esim.gradientColors.first),
                    Color(vm.esim.gradientColors.last),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Color(vm.esim.gradientColors.last).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddDataBottomSheet(esim: vm.esim),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add Data',
                      style: TextStyle(
                        fontFamily: 'Fustat',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Settings Block (iOS Inset Grouped Style)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _controlTile(
                  icon: Icons.check_circle_rounded,
                  iconColor: vm.isActiveEsim ? AppColors.homeGradientStart : AppColors.textGrey,
                  title: 'Active Data Plan',
                  subtitle: vm.isActiveEsim 
                      ? 'This is your primary connection' 
                      : 'Set as your main data plan',
                  value: vm.isActiveEsim,
                  onChanged: vm.toggleActiveEsim,
                ),
                _divider(),
                _controlTile(
                  icon: Icons.public_rounded,
                  iconColor: AppColors.textBlack,
                  title: 'Data Roaming',
                  subtitle: 'Required for this eSIM to work',
                  value: vm.isDataRoamingEnabled,
                  onChanged: vm.toggleDataRoaming,
                ),
                _divider(),
                _controlTile(
                  icon: Icons.autorenew_rounded,
                  iconColor: AppColors.textBlack,
                  title: 'Auto-Renew Plan',
                  subtitle: 'Automatically top up when empty',
                  value: vm.isAutoRenewEnabled,
                  onChanged: vm.toggleAutoRenew,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Destructive Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              onTap: vm.uninstallEsim,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 22),
              ),
              title: const Text(
                'Delete eSIM',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
            ),
          ),
        ),
        
        const SizedBox(height: 48), // Bottom padding
      ],
    );
  }

  Widget _controlTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: isLast ? 20 : 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.homeBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 0.9,
            child: CupertinoSwitch(
              value: value,
              activeTrackColor: Color(vm.esim.gradientColors.first),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Container(
        height: 1,
        color: Colors.black.withValues(alpha: 0.04),
      ),
    );
  }
}
