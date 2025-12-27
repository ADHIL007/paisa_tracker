import 'package:flutter/material.dart';
import 'package:paisa_tracker/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:paisa_tracker/navigation/bottom_navigator.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeProvider.instance.setMatchWithSystem(true);

  runApp(
    ChangeNotifierProvider.value(
      value: ThemeProvider.instance,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: materialLightTheme,
      darkTheme: materialDarkTheme,

      themeMode:
          themeProvider.isMatchWithSystem
              ? ThemeMode.system
              : (themeProvider.theme == AppThemeMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.light),

      home: const BottomNav(),
    );
  }
}
