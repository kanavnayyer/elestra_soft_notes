import 'package:esfera_notes/features/expense/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() =>
      _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  double? total;
  bool isLoading = true;

  final List<String> currencies = [
    "USD",
    "INR",
    "EUR",
    "GBP"
  ];

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  Future<void> _calculateTotal() async {
    final provider =
        context.read<ExpenseProvider>();

    setState(() {
      isLoading = true;
    });

    total =
        await provider.getTotalInBaseCurrency();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Base Currency Dropdown
            DropdownButtonFormField<String>(
              value: provider.baseCurrency,
              items: currencies
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                provider.changeBaseCurrency(value!);
                await _calculateTotal();
              },
              decoration:
                  const InputDecoration(
                      labelText: "Base Currency"),
            ),

            const SizedBox(height: 40),

            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding:
                  const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Column(
                      children: [
                        const Text(
                          "Total Expenses",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "${total?.toStringAsFixed(2)} ${provider.baseCurrency}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
