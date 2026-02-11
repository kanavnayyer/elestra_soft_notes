import 'package:esfera_notes/features/expense/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/expense_model.dart';

import '../widgets/animated_category_selector.dart';

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({super.key});

  @override
  State<AddEditExpenseScreen> createState() =>
      _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState
    extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCurrency = "USD";
  String _selectedCategory = "Food";
  DateTime _selectedDate = DateTime.now();

  final List<String> currencies = [
    "USD",
    "INR",
    "EUR",
    "GBP"
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Title
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value!.isEmpty ? "Enter title" : null,
              ),

              const SizedBox(height: 12),

              /// Amount
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                        decimal: true),
                decoration:
                    const InputDecoration(labelText: "Amount"),
                validator: (value) =>
                    value!.isEmpty ? "Enter amount" : null,
              ),

              const SizedBox(height: 12),

              /// Currency
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                items: currencies
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                },
                decoration:
                    const InputDecoration(labelText: "Currency"),
              ),

              const SizedBox(height: 16),

              /// Animated Category Selector
              AnimatedCategorySelector(
                selectedCategory: _selectedCategory,
                onSelected: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// Date Picker
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: const Text("Select Date"),
                  ),
                ],
              ),

              const Spacer(),

              /// Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final expense = ExpenseModel(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      amount: double.parse(
                          _amountController.text),
                      currency: _selectedCurrency,
                      category: _selectedCategory,
                      date: _selectedDate,
                      updatedAt: DateTime.now(),
                      isSynced: false,
                    );

                    await provider.addOrUpdateExpense(
                        expense);

                    if (!mounted) return;

                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
