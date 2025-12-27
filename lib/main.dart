import 'package:flutter/material.dart';
import 'package:paisa_tracker/sms/sms_importer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final importer = SmsImporter();

              try {
                final messages = await importer.importSms();
                debugPrint(
                  'Financial SMS imported: ${messages.length}',
                );

                for (final msg in messages.take(5)) {
                  debugPrint(
                    'FROM: ${msg.address} | BODY: ${msg.body}',
                  );
                }
              } catch (e) {
                debugPrint('SMS import failed: $e');
              }
            },
            child: const Text("Import SMS"),
          ),
        ),
      ),
    );
  }
}
