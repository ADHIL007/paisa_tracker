import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paisa_tracker/Screens/transactions/transaction-controller.dart';
import 'package:paisa_tracker/sms/sms_models.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';

class TransactionsScreenMain extends StatelessWidget {
  const TransactionsScreenMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors().background,
        title: const Text('Transactions'),
        actions: [
          Obx(
            () => IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: controller.fetchTransactions,
              tooltip: 'Refresh Transactions',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No transactions found.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.importSmsTransactions,
                  child: const Text('Import Now'),
                ),
              ],
            ),
          );
        }

        final now = DateTime.now();
        final currentMonthTransactions =
            controller.transactions.where((t) {
              final transactionDate =
                  t.date is int
                      ? DateTime.fromMillisecondsSinceEpoch(t.date as int)
                      : (t.date as DateTime);
              return transactionDate.year == now.year &&
                  transactionDate.month == now.month;
            }).toList();

        return Column(
          children: [
            _buildSummaryCard(currentMonthTransactions),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currentMonthTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = currentMonthTransactions[index];
                  return ListTile(
                    title: Text(transaction.merchant ?? 'Unknown'),
                    subtitle: Text(transaction.body),
                    trailing: Text(
                      '₹${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            transaction.type == 'credit'
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard(List<SmsTransaction> transactions) {
    final total = transactions.fold<double>(
      0.0,
      (sum, item) =>
          item.type == 'credit' ? sum + item.amount : sum - item.amount,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Balance:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: total >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Received:', style: TextStyle(fontSize: 16)),
                  Text(
                    // Use transactions list instead of controller.transactions
                    '₹${transactions.where((e) => e.type == 'credit').fold<double>(0.0, (sum, item) => sum + item.amount).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Sent:', style: TextStyle(fontSize: 16)),
                  Text(
                    // Use transactions list instead of controller.transactions
                    '₹${transactions.where((e) => e.type == 'debit').fold<double>(0.0, (sum, item) => sum + item.amount).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
