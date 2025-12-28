import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:paisa_tracker/Screens/home/widgets/initial_import_popup.dart';
import 'package:paisa_tracker/sms/sms_db_helper.dart';
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _checkTransactionsTable();
  }

  Future<void> _checkTransactionsTable() async {
    final dbHelper = SmsDbHelper();
    final isEmpty = await dbHelper.isTransactionsTableEmpty();

    if (isEmpty && !Get.isDialogOpen!) {
      Get.dialog(const InitialImportPopup(), barrierDismissible: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return GetMaterialApp(
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
