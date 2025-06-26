import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _importanceController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  String? _selectedCategory;

  final List<String> _categoryOptions = [
    "Food & Snacks",
    "Transportation",
    "School Supplies",
    "Mobile Load / Data",
    "Dorm / Boarding",
    "Health / Medicine",
    "Leisure / Entertainment",
    "Others",
  ];

  void _saveExpense() async {
    final category = _selectedCategory == "Others"
        ? _customCategoryController.text.trim()
        : _selectedCategory;

    final cost = double.tryParse(_costController.text);
    final importance = int.tryParse(_importanceController.text);

    if (category == null ||
        category.isEmpty ||
        cost == null ||
        importance == null ||
        importance < 1 ||
        importance > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid values.")),
      );
      return;
    }

    final box = Hive.box<Expense>('expenses');
    final expense = Expense(
      category: category,
      cost: cost,
      importance: importance,
      date: DateTime.now(),
    );
    await box.add(expense);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Expense saved!")));

    // Clear inputs
    setState(() {
      _selectedCategory = null;
    });
    _customCategoryController.clear();
    _costController.clear();
    _importanceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categoryOptions.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (_selectedCategory == "Others")
                TextField(
                  controller: _customCategoryController,
                  decoration: const InputDecoration(
                    labelText: "Specify Category",
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 10),
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Cost (₱)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _importanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Importance (1–5)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "※ 5 is highly preferred, 1 is the negligible.",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
