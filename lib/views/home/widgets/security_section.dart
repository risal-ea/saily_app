import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/data/models/security_state_model.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';

/// A sleek, Apple-style security section displaying real-time protection status
/// and providing quick controls for VPN, Ad Blocker, and Web Protection.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final state = vm.securityState;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Security',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Top Card: Security Status
          _statusCard(state),
          const SizedBox(height: 16),

          // Quick Controls List
          Container(
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
                  title: 'Virtual Location (VPN)',
                  value: state.isVpnEnabled,
                  onChanged: vm.toggleVpn,
                ),
                _divider(),
                _controlTile(
                  icon: Icons.block,
                  title: 'Ad Blocker',
                  value: state.isAdBlockerEnabled,
                  onChanged: vm.toggleAdBlocker,
                ),
                _divider(),
                _controlTile(
                  icon: Icons.security,
                  title: 'Web Protection',
                  value: state.isWebProtectionEnabled,
                  onChanged: vm.toggleWebProtection,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(SecurityStateModel state) {
    final isProtected = state.isFullyProtected;
    final color = isProtected ? AppColors.cardGreen1 : AppColors.cardRed1;
    final title = isProtected ? 'Protected' : 'At Risk';
    final subtitle = isProtected
        ? 'Your connection is secure.'
        : 'Action recommended to secure data.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dynamic Shield Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isProtected ? Icons.shield : Icons.gpp_maybe,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Fustat',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
                if (!isProtected) ...[
                  const SizedBox(height: 12),
                  _turnOnProtectionButton(),
                ],
                if (isProtected && state.trackersBlockedToday > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${state.trackersBlockedToday} trackers blocked today',
                    style: TextStyle(
                      fontFamily: 'Fustat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _turnOnProtectionButton() {
    return GestureDetector(
      onTap: () {
        // In a real app, this would trigger a flow to enable all protections.
        vm.toggleVpn(true);
        vm.toggleAdBlocker(true);
        vm.toggleWebProtection(true);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardRed1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: const Text(
            'Turn On Protection',
            style: TextStyle(
              fontFamily: 'Fustat',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: isLast ? 16 : 12,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textBlack, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Fustat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ),
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
      padding: const EdgeInsets.only(left: 58),
      child: Container(
        height: 1,
        color: Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}
