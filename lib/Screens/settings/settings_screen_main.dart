import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_db_helper.dart';

class SettingsScreenMain extends StatefulWidget {
  const SettingsScreenMain({Key? key}) : super(key: key);

  @override
  _SettingsScreenMainState createState() => _SettingsScreenMainState();
}

class _SettingsScreenMainState extends State<SettingsScreenMain> {
  final SmsDbHelper _dbHelper = SmsDbHelper();

  Future<void> _confirmDeleteAllData() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete all transaction data?'),
                Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteAllData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllData() async {
    await _dbHelper.deleteAllTransactions();
    Get.snackbar(
      'Data Deleted',
      'All transaction data has been deleted.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Delete All Data',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _confirmDeleteAllData,
          ),
          // Add other settings here in the future
        ],
      ),
    );
  }
}
