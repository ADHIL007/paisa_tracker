import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paisa_tracker/theme/app_theme.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';

enum GlassSnackType { success, error, warning }

void showGlassSnackBar({
  String? title,
  required String message,
  GlassSnackType type = GlassSnackType.success,
  Duration duration = const Duration(seconds: 3),
}) {
  final colors = customColors();

  Get.rawSnackbar(
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    duration: duration,
    messageText: _GlassSnackBarContent(
      title: title,
      message: message,
      colors: colors,
      type: type,
    ),
  );
}

class _GlassSnackBarContent extends StatelessWidget {
  final String? title;
  final String message;
  final ColorTheme colors;
  final GlassSnackType type;

  const _GlassSnackBarContent({
    this.title,
    required this.message,
    required this.colors,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accentGradient(type);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: colors.background.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1.2, color: accent[0].withOpacity(0.9)),
            boxShadow: [
              BoxShadow(
                color: accent[1].withOpacity(0.45),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GradientGlowDot(gradient: accent),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientGlowDot extends StatelessWidget {
  final List<Color> gradient;

  const _GradientGlowDot({required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: gradient),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.9),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

List<Color> _accentGradient(GlassSnackType type) {
  switch (type) {
    case GlassSnackType.success:
      return const [Color(0xFF00E676), Color(0xFF1DE9B6)];
    case GlassSnackType.error:
      return const [Color(0xFFFF5252), Color(0xFFFF1744)];
    case GlassSnackType.warning:
      return const [Color(0xFFFFC107), Color(0xFFFF9800)];
  }
}
