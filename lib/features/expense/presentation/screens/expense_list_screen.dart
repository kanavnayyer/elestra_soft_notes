import 'package:esfera_notes/features/expense/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/expense_card.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Expenses",
          style: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline,
            color: Colors.white,),
            onPressed: () {
              Navigator.pushNamed(context, '/summary');
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.expenses.isEmpty
              ? const _EmptyState()
              : const AnimatedListView(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3949AB),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        icon: const Icon(Icons.add,
        color: Colors.white,),
label: const Text(
  "Add Expense",
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ),
),
      ),
    );
  }
}

class AnimatedListView extends StatelessWidget {
  const AnimatedListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.expenses.length,
      itemBuilder: (context, index) {
        final expense = provider.expenses[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Dismissible(
            key: ValueKey(expense.id),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              provider.deleteExpense(expense.id);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Expense Deleted"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: ExpenseCard(expense: expense),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Expenses Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap + to add your first expense",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
