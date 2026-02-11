import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service.dart';
import '../models/expense_model.dart';

class ExpenseLocalDataSource {

  Future<void> upsertExpense(ExpenseModel expense) async {
    final db = await DatabaseService.database;

    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all expenses
  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await DatabaseService.database;

    final result = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );

    return result.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  /// Delete expense
  Future<void> deleteExpense(String id) async {
    final db = await DatabaseService.database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ExpenseModel>> getUnsyncedExpenses() async {
    final db = await DatabaseService.database;

    final result = await db.query(
      'expenses',
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    return result.map((e) => ExpenseModel.fromMap(e)).toList();
  }


  Future<void> markAsSynced(String id) async {
    final db = await DatabaseService.database;

    await db.update(
      'expenses',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
