import '../../domain/expense_repository.dart';
import '../local/expense_local_data_source.dart';
import '../models/expense_model.dart';
import '../remote/expense_remote_data_source.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Get All Expenses (Always from local DB - Offline First)
  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return await localDataSource.getAllExpenses();
  }

  /// Add or Update Expense (Offline First)
  @override
  Future<void> addOrUpdateExpense(ExpenseModel expense) async {
    final updatedExpense = expense.copyWith(
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await localDataSource.upsertExpense(updatedExpense);
  }

  /// Delete Expense
  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }

  /// Currency Conversion via API
  @override
  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    return await remoteDataSource.convertCurrency(
      amount: amount,
      from: from,
      to: to,
    );
  }

  /// Sync Pending Expenses
  @override
  Future<void> syncPendingExpenses() async {
    final unsynced = await localDataSource.getUnsyncedExpenses();

    for (final expense in unsynced) {
      try {
        await remoteDataSource.syncExpense(expense);

        await localDataSource.markAsSynced(expense.id);
      } catch (_) {
        // Keep it in queue for next retry
      }
    }
  }
}
