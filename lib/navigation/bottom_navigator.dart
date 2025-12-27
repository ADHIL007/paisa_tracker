import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paisa_tracker/constants/image_constants.dart';
import 'package:paisa_tracker/theme/app_theme.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';
import '../screens/home/home_screen_main.dart';
import '../screens/transactions/transactions-screen_main.dart';
import '../screens/budget/budget_screen_main.dart';
import '../screens/settings/settings_screen_main.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomeScreenMain(),
    TransactionsScreenMain(),
    BudgetScreenMain(),
    SettingsScreenMain(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = customColors();

    return Scaffold(
      backgroundColor: colors.background,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.35),
                  width: 0.6,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),

            child: BottomNavigationBar(
              elevation: 3,
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: colors.textPrimary,
              unselectedItemColor: colors.textSecondary,
              showUnselectedLabels: true,
              items: [
                _navItem(
                  label: 'Home',
                  iconPath: ImageConstants.home_icon,
                  isActive: _index == 0,
                  colors: colors,
                ),
                _navItem(
                  label: 'Transactions',
                  iconPath: ImageConstants.transaction_icon,
                  isActive: _index == 1,
                  colors: colors,
                ),
                _navItem(
                  label: 'Budget',
                  iconPath: ImageConstants.budget_icon,
                  isActive: _index == 2,
                  colors: colors,
                ),
                _navItem(
                  label: 'Settings',
                  iconPath: ImageConstants.settings_icon,
                  isActive: _index == 3,
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required String label,
    required String iconPath,
    required bool isActive,
    required ColorTheme colors,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isActive)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: customColors().secondaryGradient[0].withOpacity(0.4),
                    offset: const Offset(0, 10),
                    blurRadius: 30,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? colors.textPrimary : colors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
