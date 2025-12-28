import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_filter.dart';
import 'package:another_telephony/telephony.dart';
import 'package:paisa_tracker/sms/sms_models.dart';
import 'package:paisa_tracker/widgets/snackbar/glass_snackbar.dart';

class SmsImporter {
  final Telephony _telephony = Telephony.instance;
  final FinancialSmsFilter _filter = FinancialSmsFilter();

  Future<List<SmsTransaction>> importSms() async {
    final bool? permissionGranted = await _telephony.requestSmsPermissions;

    if (permissionGranted != true) {
      showGlassSnackBar(
        title: "Permission Denied",
        message: "Please grant permission to access SMS",
        type: GlassSnackType.error,
      );

      return [];
    }

    final List<SmsMessage> allMessages = await _telephony.getInboxSms(
      columns: [
        SmsColumn.BODY,
        SmsColumn.ADDRESS,
        SmsColumn.DATE,
        SmsColumn.ID,
      ],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );

    final List<SmsTransaction> transactions = [];

    for (final msg in allMessages) {
      if (!_filter.isFinancial(msg)) continue;

      final body = msg.body ?? '';

      final double? amount = _extractAmount(body);
      if (amount == null) continue; // safety

      final String type = _detectType(body);
      final String? merchant = _extractMerchant(body);

      transactions.add(
        SmsTransaction(
          id: msg.id?.toString() ?? '',
          address: msg.address ?? '',
          date: DateTime.fromMillisecondsSinceEpoch(msg.date ?? 0),
          body: body,
          amount: amount,
          type: type,
          merchant: merchant,
          category: null,
        ),
      );
    }

    return transactions;
  }

  // -----------------------------
  // PARSERS
  // -----------------------------

  double? _extractAmount(String text) {
    final match = RegExp(
      r'(₹|rs\.?|inr)\s?([\d,]+(?:\.\d+)?)',
      caseSensitive: false,
    ).firstMatch(text);

    if (match == null) return null;

    final raw = match.group(2)!.replaceAll(',', '');
    return double.tryParse(raw);
  }

  String _detectType(String text) {
    final t = text.toLowerCase();

    if (t.contains('credited') || t.contains('deposit')) {
      return 'credit';
    }
    return 'debit';
  }

  String? _extractMerchant(String text) {
    final patterns = [
      RegExp(r'at\s+([a-z0-9 &.-]+)', caseSensitive: false),
      RegExp(r'to\s+([a-z0-9 &.-]+)', caseSensitive: false),
      RegExp(r'trf to\s+([a-z0-9 &.-]+)', caseSensitive: false),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(text);
      if (m != null) {
        return m.group(1)?.trim();
      }
    }
    return null;
  }
}
