import '../data/models/expense_model.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseModel>> getExpenses();

  Future<void> addOrUpdateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);

  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });

  Future<void> syncPendingExpenses();
}
