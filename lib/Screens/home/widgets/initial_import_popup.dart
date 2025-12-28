import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_db_helper.dart';
import 'package:paisa_tracker/sms/sms_importer.dart';
import 'package:paisa_tracker/widgets/snackbar/glass_snackbar.dart';

class InitialImportPopup extends StatefulWidget {
  const InitialImportPopup({super.key});

  @override
  State<InitialImportPopup> createState() => _InitialImportPopupState();
}

class _InitialImportPopupState extends State<InitialImportPopup> {
  bool _isImporting = false;
  String _progressMessage = '';

  double _progress = 0.0;
  Future<void> _importAndSaveSms() async {
    if (_isImporting) return;

    setState(() {
      _isImporting = true;
      _progress = 0.0;
      _progressMessage = 'Importing transactions...';
    });

    try {
      final smsImporter = SmsImporter();
      final dbHelper = SmsDbHelper();

      final transactions = await smsImporter.importSms();

      if (transactions.isEmpty) {
        Get.back();
        showGlassSnackBar(
          title: 'Info',
          message: 'No new transactions found to import.',
          type: GlassSnackType.warning,
        );
        return;
      }

      for (int i = 0; i < transactions.length; i++) {
        await dbHelper.insertTransaction(transactions[i]);

        if (!mounted) return;

        setState(() {
          _progress = (i + 1) / transactions.length;
          _progressMessage =
              'Saving ${i + 1} / ${transactions.length} transactions';
        });
      }

      if (!mounted) return;

      Get.back();
      showGlassSnackBar(
        title: 'Success',
        message: 'Imported ${transactions.length} transactions successfully.',
        type: GlassSnackType.success,
      );
    } catch (e) {
      if (mounted) {
        Get.back();
        showGlassSnackBar(
          title: 'Failed',
          message: 'Failed to import transactions.',
          type: GlassSnackType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 0.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Import Previous SMS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'To get started, import your existing\ntransaction SMS for a complete\nfinancial history.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _PrimaryButton(
                  text: 'Import Now',
                  onTap: _importAndSaveSms,
                  isLoading: _isImporting,
                  progressMessage: _progressMessage,
                  progress: _progress,
                ),

                const SizedBox(height: 12),
                _SecondaryButton(
                  text: 'Not Now',
                  onTap: () {
                    if (!_isImporting) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final String message;
  const _GradientProgressBar({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFF00b09b), Color(0xFF96c93d)],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: const SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final String progressMessage;
  final double progress;

  const _PrimaryButton({
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.progressMessage = '',
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child:
          isLoading
              ? _NeonProgressButton(
                message: progressMessage,
                progress: progress,
              )
              : GestureDetector(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FACFE), Color(0xFF9B5CFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF9B5CFF).withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
    );
  }
}

class _NeonProgressButton extends StatelessWidget {
  final String message;
  final double progress;

  const _NeonProgressButton({required this.message, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF262626)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          _NeonSegmentBar(progress: progress),
          Align(
            alignment: Alignment.center,
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonSegmentBar extends StatelessWidget {
  final double progress;

  const _NeonSegmentBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final fillWidth = constraints.maxWidth * progress;

          return Stack(
            children: [
              Container(color: Colors.black),
              Container(
                width: fillWidth,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB7FF00), Color(0xFF57FF00)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB7FF00).withOpacity(0.9),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              _SegmentOverlay(),
              _GlossOverlay(),
            ],
          );
        },
      ),
    );
  }
}

class _SegmentOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        16,
        (_) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}

class _GlossOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.35), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SecondaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.white70),
        ),
      ),
    );
  }
}
