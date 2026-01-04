import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_db_helper.dart';
import 'package:paisa_tracker/theme/app_theme.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';
import 'package:paisa_tracker/widgets/snackbar/glass_snackbar.dart';
import 'package:provider/provider.dart';

class SettingsScreenMain extends StatefulWidget {
  const SettingsScreenMain({super.key});

  @override
  State<SettingsScreenMain> createState() => _SettingsScreenMainState();
}

class _SettingsScreenMainState extends State<SettingsScreenMain> {
  final SmsDbHelper _dbHelper = SmsDbHelper();

  Future<void> _confirmDeleteAllData() async {
    final colors = customColors();

    return Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.background.withOpacity(0.7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colors.primaryGradient[0].withOpacity(0.6),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Delete All Data?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will permanently remove all transactions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _OutlinedButton(
                          text: 'Cancel',
                          onTap: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DangerButton(
                          text: 'Delete',
                          onTap: () async {
                            await _dbHelper.deleteAllTransactions();
                            Get.back();
                            showGlassSnackBar(
                              title: 'Deleted',
                              message: 'All transaction data has been removed.',
                              type: GlassSnackType.error,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = customColors();

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _GlassTile(
                    icon: Icons.brightness_auto,
                    title: 'Match with System',
                    trailing: Switch(
                      value: themeProvider.isMatchWithSystem,
                      onChanged: themeProvider.setMatchWithSystem,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GlassTile(
                    icon:
                        themeProvider.theme == AppThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: themeProvider.theme == AppThemeMode.dark,
                      onChanged:
                          themeProvider.isMatchWithSystem
                              ? null
                              : (v) => themeProvider.setTheme(
                                v ? AppThemeMode.dark : AppThemeMode.light,
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _GlassTile(
                    icon: Icons.delete_forever,
                    iconColor: Colors.redAccent,
                    title: 'Delete All Data',
                    titleColor: Colors.redAccent,
                    onTap: _confirmDeleteAllData,
                  ),
                  const SizedBox(height: 24),
                  _GlassTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Paisa Tracker',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2024 Paisa Tracker',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _GlassTile(icon: Icons.share, title: 'Share'),
                  const SizedBox(height: 12),
                  _GlassTile(icon: Icons.feedback, title: 'Feedback'),
                  const SizedBox(height: 12),
                  _GlassTile(icon: Icons.privacy_tip, title: 'Privacy Policy'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _GlassTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;

  const _GlassTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = customColors();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.background.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? colors.textPrimary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: titleColor ?? colors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlinedButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _DangerButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Colors.redAccent, Colors.deepOrange],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
