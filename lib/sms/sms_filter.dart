import 'package:another_telephony/telephony.dart';

class FinancialSmsFilter {
  static const List<String> _blockKeywords = [
    'otp',
    'verification',
    'one time password',
    'login',
    'password',
    'offer',
    'promo',
    'cashback',
    'discount',
    'sale',
  ];

  static const List<String> _infoKeywords = [
    'free transaction',
    'free transactions',
    'charges applicable',
    'non-cash',
    'limit',
    'limits',
    'balance enquiry',
    'atm',
    'this month',
    'available',
    'statement',
    'alert',
    'reminder',
  ];

  static const List<String> _txnVerbs = [
    'debit',
    'debited',
    'credit',
    'credited',
    'spent',
    'paid',
    'purchase',
  ];

  bool isRelevant(SmsMessage msg) {
    final String body = (msg.body ?? '').toLowerCase();
    if (body.isEmpty) return false;

    for (final k in _blockKeywords) {
      if (body.contains(k)) return false;
    }

    for (final k in _infoKeywords) {
      if (body.contains(k)) return false;
    }

    final bool hasAmount = _hasAmount(body);
    final bool hasTxnVerb = _hasTxnVerb(body);

    return hasAmount && hasTxnVerb;
  }

  bool _hasAmount(String body) {
    return RegExp(r'(₹|rs\.?|inr)\s?\d').hasMatch(body);
  }

  bool _hasTxnVerb(String body) {
    for (final v in _txnVerbs) {
      if (body.contains(v)) return true;
    }
    return false;
  }
}
