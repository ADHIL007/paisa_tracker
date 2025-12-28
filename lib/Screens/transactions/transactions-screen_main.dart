import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_db_helper.dart';
import 'package:paisa_tracker/sms/sms_importer.dart';
import 'package:paisa_tracker/sms/sms_models.dart';

class TransactionsScreenMain extends StatefulWidget {
  const TransactionsScreenMain({Key? key}) : super(key: key);

  @override
  _TransactionsScreenMainState createState() => _TransactionsScreenMainState();
}

class _TransactionsScreenMainState extends State<TransactionsScreenMain> {
  final SmsDbHelper _dbHelper = SmsDbHelper();
  List<SmsTransaction> _transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });
    final transactions = await _dbHelper.getTransactions();
    setState(() {
      _transactions = transactions;
      _isLoading = false;
    });
  }

  Future<void> _importSmsTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final smsImporter = SmsImporter();
    final transactions = await smsImporter.importSms();

    if (transactions.isNotEmpty) {
      for (final transaction in transactions) {
        await _dbHelper.insertTransaction(transaction);
      }
      Get.snackbar('Success', 'Imported ${transactions.length} transactions.');
      _loadTransactions();
    } else {
      Get.snackbar('Info', 'No new transactions found to import.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: _isLoading ? null : _importSmsTransactions,
            tooltip: 'Import SMS Transactions',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No transactions found.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _importSmsTransactions,
                        child: const Text('Import Now'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactions[index];
                    return ListTile(
                      title: Text(transaction.merchant ?? 'Unknown'),
                      subtitle: Text(transaction.body),
                      trailing: Text(
                        '₹${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.type == 'credit'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
