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
    backgroundColor: const Color(0xFFF6F8FB),
    appBar: AppBar(
      centerTitle: true,
      elevation: 0,
      title: const Text(
        "Add Expense",
        style: TextStyle(fontWeight: FontWeight.bold),
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
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

            /// TITLE
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration("Title"),
              validator: (value) =>
                  value!.isEmpty ? "Enter title" : null,
            ),

            const SizedBox(height: 16),

            /// AMOUNT
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration("Amount"),
              validator: (value) =>
                  value!.isEmpty ? "Enter amount" : null,
            ),

            const SizedBox(height: 16),

            /// CURRENCY
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: _inputDecoration("Currency"),
              borderRadius: BorderRadius.circular(16),
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
            ),

            const SizedBox(height: 20),

            /// CATEGORY
            AnimatedCategorySelector(
              selectedCategory: _selectedCategory,
              onSelected: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            /// DATE PICKER CARD
Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () async {
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
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${_selectedDate.toLocal()}".split(' ')[0],
            style: const TextStyle(
                fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.calendar_today),
        ],
      ),
    ),
  ),
),
            const SizedBox(height: 40),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final expense = ExpenseModel(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      currency: _selectedCurrency,
                      category: _selectedCategory,
                      date: _selectedDate,
                      updatedAt: DateTime.now(),
                      isSynced: false,
                    );

                    await provider.addOrUpdateExpense(expense);

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Save Expense",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
