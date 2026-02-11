import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/expense/data/local/expense_local_data_source.dart';
import 'features/expense/data/remote/expense_remote_data_source.dart';
import 'features/expense/data/repository/expense_repository_impl.dart';
import 'features/expense/domain/expense_repository.dart';
import 'features/expense/presentation/providers/expense_provider.dart';
import 'features/expense/presentation/screens/expense_list_screen.dart';
import 'features/expense/presentation/screens/add_edit_expense_screen.dart';
import 'features/expense/presentation/screens/summary_screen.dart';

void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ExpenseRepositoryImpl(
      localDataSource: ExpenseLocalDataSource(),
      remoteDataSource: ExpenseRemoteDataSource(),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(repository: repository)
            ..loadExpenses(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Multi Currency Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const ExpenseListScreen(),
          '/add': (_) => const AddEditExpenseScreen(),
          '/summary': (_) => const SummaryScreen(),
        },
      ),
    );
  }
}
