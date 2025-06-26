import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../utils/quicksort_expenses.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Records"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Expense>('expenses').listenable(),
        builder: (context, Box<Expense> box, _) {
          final expenses = box.values.toList().cast<Expense>();

          if (expenses.isEmpty) {
            return const Center(child: Text("No expenses recorded yet."));
          }

          // 🔽 Sort by importance descending
          final sortedExpenses = quickSortExpenses(
            expenses,
            SortBy.importance,
            descending: true,
          );

          return ListView.builder(
            itemCount: sortedExpenses.length,
            itemBuilder: (context, index) {
              final e = sortedExpenses[index]; // <-- this defines `e`

              return ListTile(
                title: Text(e.category),
                subtitle: Text(
                  "₱${e.cost.toStringAsFixed(2)} • Importance: ${e.importance}",
                ),
                trailing: Text(
                  "${e.date.month}/${e.date.day}/${e.date.year}",
                  style: const TextStyle(fontSize: 12),
                ),
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Expense"),
                      content: const Text(
                        "Are you sure you want to delete this expense?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await e.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Expense deleted.")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
