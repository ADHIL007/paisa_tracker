import 'package:another_telephony/telephony.dart';

class FinancialSmsFilter {

  // =========================
  // STAGE 1 — FINANCIAL CONTEXT
  // =========================
  bool _isFinancialContext(String body) {
    if (body.isEmpty || body.startsWith('[')) return false;

    const hints = [
      '₹', 'rs', 'inr',
      'bank', 'upi', 'account', 'a/c',
      'debit', 'credit', 'paid', 'spent',
      'loan', 'emi', 'mandate', 'card',
      'wallet', 'prepaid', 'balance',
      'recharge', 'bill'
    ];

    for (final h in hints) {
      if (body.contains(h)) return true;
    }
    return false;
  }

  // =========================
  // STAGE 2 — CASHFLOW RELATED
  // =========================
  bool _isCashflowRelated(String body) {
    const blockers = [
      // security / settings
      'otp', 'kyc', 'pin', 'limit', 'limits',
      'biometric', 'e-sign', 'esign',

      // telecom / benefits
      'data', 'gb', 'validity', 'free data',
      'extra data', 'benefit', 'experience',

      // promo / store
      'promo', 'offer', 'discount',
      'welcome', 'visit today', 'store',
      'browse', 'stream', 'download',
      'super-fast',
    ];

    for (final b in blockers) {
      if (body.contains(b)) return false;
    }
    return true;
  }

  // =========================
  // STAGE 3 — EXECUTED CASHFLOW
  // =========================
  bool _isExecutedTransaction(String body) {
    const absoluteBlockers = [
      // loan / emi
      'loan', 'emi', 'repayment', 'repay',
      'hdb', 'hdbfs', 'kfs', 'sanction',
      'agreement', 'credit bureau',
      'loan closed', 'loan approved',

      // mandate / authorization
      'mandate', 'upi-mandate', 'autopay',
      'e-mandate', 'nach',
      'standing instruction', 'si registration',
      'si cancelled',

      // request / pending
      'requested', 'request', 'once approved',
      'approve', 'approval pending',
      'will be debited', 'will be credited',
      'collect request', 'upi request',
      'pay request',

      // failed / refund
      'failed', 'refund', 'refunded',
      'reversed', 'not completed',
    ];

    for (final b in absoluteBlockers) {
      if (body.contains(b)) return false;
    }

    const txnSignals = [
      'debited', 'credited',
      'spent', 'paid',
      'withdrawn', 'deposited',
      'imps', 'neft', 'rtgs'
    ];

    bool hasTxnSignal = false;
    for (final s in txnSignals) {
      if (body.contains(s)) {
        hasTxnSignal = true;
        break;
      }
    }

    final hasAmount =
        RegExp(r'(₹|rs\.?|inr)\s?\d').hasMatch(body);

    return hasTxnSignal && hasAmount;
  }

  // =========================
  // PUBLIC API
  // =========================
  bool isFinancial(SmsMessage msg) {
    final body = (msg.body ?? '').toLowerCase().trim();

    if (!_isFinancialContext(body)) return false;
    if (!_isCashflowRelated(body)) return false;
    if (!_isExecutedTransaction(body)) return false;

    return true;
  }
}
