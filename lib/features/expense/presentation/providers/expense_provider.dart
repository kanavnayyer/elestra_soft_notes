import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/expense_model.dart';
import '../../domain/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository repository;

  ExpenseProvider({required this.repository}) {
    _init();
  }

  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String _baseCurrency = "USD";

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  String get baseCurrency => _baseCurrency;

  /// Init
  void _init() async {
    await loadExpenses();
    await syncExpenses(); // try immediate sync
    _listenToConnectivity();
  }

  /// Listen for internet changes
  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        syncExpenses();
      }
    });
  }

  /// Load Expenses
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await repository.getExpenses();

    _isLoading = false;
    notifyListeners();
  }

  /// Add or Update Expense
  Future<void> addOrUpdateExpense(ExpenseModel expense) async {
    await repository.addOrUpdateExpense(expense);
    await loadExpenses();
  }

  /// Delete Expense
  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
    await loadExpenses();
  }

  /// Sync Pending Expenses
  Future<void> syncExpenses() async {
    if (_isSyncing) return;

    _isSyncing = true;
    notifyListeners();

    await repository.syncPendingExpenses();
    await loadExpenses();

    _isSyncing = false;
    notifyListeners();
  }

  /// Change Base Currency
  void changeBaseCurrency(String currency) {
    _baseCurrency = currency;
    notifyListeners();
  }

  /// Convert Total to Base Currency
  Future<double> getTotalInBaseCurrency() async {
    double total = 0;

    for (final expense in _expenses) {
      if (expense.currency == _baseCurrency) {
        total += expense.amount;
      } else {
        final converted = await repository.convertCurrency(
          amount: expense.amount,
          from: expense.currency,
          to: _baseCurrency,
        );
        total += converted;
      }
    }

    return total;
  }
}
