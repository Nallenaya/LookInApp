import 'package:flutter/material.dart';

class HrdTheme {
  static const Color primaryBlue = Color(0xFF1769FF);
  static const Color darkBlue = Color(0xFF2855D9);
  static const Color cyanDate = Color(0xFF00BCEB);
  static const Color textDark = Color(0xFF17191D);
  static const Color textGrey = Color(0xFF7C8798);
  static const Color textLightGrey = Color(0xFF9A9DA3);
  static const Color scaffoldBg = Color(0xFFF4F5F7);
  static const Color greenPresent = Color(0xFF176522);
  static const Color greenBadgeBg = Color(0xFFDDF5E8);
  static const Color greenBadgeText = Color(0xFF18734A);
  static const Color purpleBadgeBg = Color(0xFFF0E2FA);
  static const Color purpleBadgeText = Color(0xFF7B3FB4);
  static const Color blueBadgeBg = Color(0xFFE0EDFF);
  static const Color blueBadgeText = Color(0xFF2460D9);
  static const Color orangeBadgeBg = Color(0xFFFFE9CF);
  static const Color orangeBadgeText = Color(0xFFB05A00);
  static const Color redBadgeBg = Color(0xFFFCE8E8);
  static const Color redBadgeText = Color(0xFFB42318);
  static const Color redBorder = Color(0xFFA31D1D);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}

class HrdTopBar extends StatelessWidget {
  const HrdTopBar({
    super.key,
    this.showAvatar = false,
    this.avatarUrl,
    this.onAvatarTap,
  });

  final bool showAvatar;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/lookin_logo.png',
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fingerprint, color: HrdTheme.primaryBlue, size: 24),
                SizedBox(width: 4),
                Text(
                  'LookIn',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: HrdTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          if (showAvatar)
            GestureDetector(
              onTap: onAvatarTap,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/avatar_persetujuan.png'),
              ),
            ),
        ],
      ),
    );
  }
}

class HrdStepIndicator extends StatelessWidget {
  const HrdStepIndicator({
    super.key,
    this.activeStep = 0,
    this.totalSteps = 4,
  });

  final int activeStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index == activeStep;
        return Expanded(
          child: Container(
            height: 2.5,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 4,
              right: index == totalSteps - 1 ? 0 : 4,
            ),
            decoration: BoxDecoration(
              color: isActive ? HrdTheme.primaryBlue : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

