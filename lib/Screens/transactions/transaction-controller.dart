import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_db_helper.dart';
import 'package:paisa_tracker/sms/sms_importer.dart';
import 'package:paisa_tracker/sms/sms_models.dart';

class TransactionController extends GetxController {
  var transactions = <SmsTransaction>[].obs;
  var isLoading = false.obs;

  final SmsDbHelper _dbHelper = SmsDbHelper();

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() async {
    try {
      isLoading(true);
      final fetchedTransactions = await _dbHelper.getTransactions();
      transactions.value = fetchedTransactions;
    } finally {
      isLoading(false);
    }
  }

  Future<void> importSmsTransactions() async {
    try {
      isLoading(true);
      final smsImporter = SmsImporter();
      final importedTransactions = await smsImporter.importSms();

      if (importedTransactions.isNotEmpty) {
        for (final transaction in importedTransactions) {
          await _dbHelper.insertTransaction(transaction);
        }
        Get.snackbar(
          'Success',
          'Imported ${importedTransactions.length} transactions.',
        );
        fetchTransactions();
      } else {
        Get.snackbar('Info', 'No new transactions found to import.');
      }
    } finally {
      isLoading(false);
    }
  }
}
