import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/viewmodels/esim_details_viewmodel.dart';

/// Section containing toggle controls and secondary actions for an eSIM.
class EsimControlsSection extends StatelessWidget {
  const EsimControlsSection({super.key, required this.vm});

  final EsimDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top-up CTA
        if (vm.esim.isActive)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.homeGradientStart,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Add Data',
                  style: TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

        // Settings Block
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _controlTile(
                  icon: Icons.public,
                  title: 'Data Roaming',
                  subtitle: 'Required for this eSIM to work',
                  value: vm.isDataRoamingEnabled,
                  onChanged: vm.toggleDataRoaming,
                ),
                _divider(),
                _controlTile(
                  icon: Icons.autorenew,
                  title: 'Auto-Renew Plan',
                  subtitle: 'Automatically top up when data runs out',
                  value: vm.isAutoRenewEnabled,
                  onChanged: vm.toggleAutoRenew,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),

        // Destructive Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: ListTile(
              onTap: vm.uninstallEsim,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
              title: const Text(
                'Delete eSIM',
                style: TextStyle(
                  fontFamily: 'Fustat',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        ),
        
        const SizedBox(height: 48), // Bottom padding
      ],
    );
  }

  Widget _controlTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: isLast ? 16 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.homeBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textBlack, size: 20),
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
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.homeGradientStart,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Container(
        height: 1,
        color: Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}
