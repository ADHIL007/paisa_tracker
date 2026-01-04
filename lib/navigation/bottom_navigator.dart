import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paisa_tracker/constants/image_constants.dart';
import 'package:paisa_tracker/theme/app_theme.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final colors = customColors();

        return Scaffold(
          body: IndexedStack(index: _index, children: _pages),
          bottomNavigationBar: GlassContainer(
            width: double.infinity,
            height: 88,
            child: BottomNavigationBar(
              elevation: 0,
              iconSize: 24,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showSelectedLabels: true,
              showUnselectedLabels: true,

              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: colors.textPrimary,
              unselectedItemColor: colors.textSecondary,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),

              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w300,
              ),

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
        );
      },
    );
  }

  BottomNavigationBarItem _navItem({
    required String label,
    required String iconPath,
    required bool isActive,
    required ColorTheme colors,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Light theme soft shine
              if (isActive && !isDark)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),

              // Dark theme glow (existing idea, refined)
              if (isActive && isDark)
                SvgPicture.asset(
                  iconPath,

                  colorFilter: const ColorFilter.mode(
                    Colors.white70,
                    BlendMode.srcIn,
                  ),
                ),

              SvgPicture.asset(
                iconPath,

                colorFilter: ColorFilter.mode(
                  isActive
                      ? (isDark ? Colors.white : colors.textPrimary)
                      : colors.textSecondary.withAlpha(100),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const GlassContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = customColors();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            // Slight tint instead of pure white
            color: colors.background.withOpacity(
              Theme.of(context).brightness == Brightness.light ? 0.65 : 0.55,
            ),

            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),

            border: Border(
              top: BorderSide(
                color: colors.border.withOpacity(0.7),
                width: 0.6,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  Theme.of(context).brightness == Brightness.light
                      ? 0.04
                      : 0.25,
                ),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
