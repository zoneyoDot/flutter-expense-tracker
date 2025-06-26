import 'package:centsiblefinal/utils/quicksort_expenses.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../utils/knapsack_budget.dart';
import '../models/settings.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  final TextEditingController _budgetController = TextEditingController();
  List<Expense> _recommendedExpenses = [];

  @override
  void initState() {
    super.initState();
    // Load initial budget from settings
    final settingsBox = Hive.box<Settings>('settings');
    final settings = settingsBox.get('user_settings');
    if (settings != null) {
      _budgetController.text = settings.weeklyBudget.toStringAsFixed(0);
    }
  }

  void _analyzeBudget() {
    final input = double.tryParse(_budgetController.text.trim());
    if (input == null || input <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid budget.")),
      );
      return;
    }

    // Save to Hive
    final settingsBox = Hive.box<Settings>('settings');
    final settings = settingsBox.get('user_settings')!;
    settings.weeklyBudget = input;
    settings.save();

    final expenses = Hive.box<Expense>('expenses').values.toList();
    final result = knapsackExpenses(expenses, input);

    //sort by importance descending
    result.sort((a, b) => b.importance.compareTo(a.importance));

    setState(() {
      _recommendedExpenses = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Advisor"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFFEEBE),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Enter your weekly budget (₱):",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "e.g. 120",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeBudget,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
              child: const Text("Analyze Budget"),
            ),
            const SizedBox(height: 20),
            if (_recommendedExpenses.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📌 Recommended Expenses:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _recommendedExpenses.length,
                        itemBuilder: (context, index) {
                          final e = _recommendedExpenses[index];
                          return Card(
                            child: ListTile(
                              title: Text(e.category),
                              subtitle: Text(
                                "₱${e.cost.toStringAsFixed(2)} • Importance: ${e.importance}",
                              ),
                              trailing: Text(
                                "${e.date.month}/${e.date.day}/${e.date.year}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        },
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
