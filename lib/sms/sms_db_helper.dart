import 'package:flutter/material.dart';
import 'package:paisa_tracker/sms/sms_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SmsDbHelper {
  static const String _transactionsTable = 'transactions';

  SmsDbHelper();

  Future<Database> _getDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'sms_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_transactionsTable(
            id TEXT PRIMARY KEY,
            address TEXT,
            date INTEGER,
            body TEXT,
            amount REAL,
            type TEXT,
            category TEXT,
            merchant TEXT
          )
          ''');
      },
    );
  }

  Future<bool> isTransactionsTableEmpty() async {
    try {
      final db = await _getDatabase();

      final tableCheck = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [_transactionsTable],
      );

      if (tableCheck.isEmpty) {
        return true;
      }

      final result = await db.rawQuery(
        'SELECT COUNT(*) FROM $_transactionsTable',
      );

      final count = Sqflite.firstIntValue(result) ?? 0;
      return count == 0;
    } catch (e) {
      debugPrint('isTransactionsTableEmpty failed: $e');
      return true;
    }
  }

  Future<void> insertTransaction(SmsTransaction transaction) async {
    final db = await _getDatabase();
    await db.insert(
      _transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SmsTransaction>> getTransactions() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_transactionsTable);
    return List.generate(maps.length, (i) {
      return SmsTransaction.fromMap(maps[i]);
    });
  }

  Future<void> deleteTransaction(String id) async {
    final db = await _getDatabase();
    await db.delete(_transactionsTable, where: 'id = ?', whereArgs: [id]);
  }
}
