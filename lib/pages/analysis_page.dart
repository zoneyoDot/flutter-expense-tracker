// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../models/expense.dart';
// import '../utils/quicksort_expenses.dart';

// class AnalysisPage extends StatelessWidget {
//   const AnalysisPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Spending Analysis"),
//         backgroundColor: Colors.black87,
//         foregroundColor: Colors.white,
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: Hive.box<Expense>('expenses').listenable(),
//         builder: (context, Box<Expense> box, _) {
//           final expenses = box.values.toList();

//           print("🔍 All expenses: $expenses");

//           if (expenses.isEmpty) {
//             print("⚠️ No expenses found.");
//             return const Center(child: Text("No data to analyze yet."));
//           }

//           // Group by category
//           final Map<String, double> categoryTotals = {};
//           for (var e in expenses) {
//             if (e.category.trim().isEmpty) continue;
//             categoryTotals[e.category] =
//                 (categoryTotals[e.category] ?? 0) + e.cost;
//           }

//           print("📊 Category Totals: $categoryTotals");

//           // Convert map to list and sort descending
//           final sortedEntries = categoryTotals.entries.toList()
//             ..sort((a, b) => b.value.compareTo(a.value));

//           print("🧮 Sorted Entries: $sortedEntries");

//           final totalSpent = sortedEntries.fold<double>(
//             0,
//             (sum, entry) => sum + entry.value,
//           );

//           print("💸 Total Spent: $totalSpent");

//           // Generate distinct colors
//           List<Color> generateColors(int count) {
//             return List.generate(count, (index) {
//               final hue = (360 * index / count).toDouble();
//               return HSLColor.fromAHSL(1, hue, 0.6, 0.6).toColor();
//             });
//           }

//           final colors = generateColors(sortedEntries.length);

//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 const Text(
//                   "Spending by Category",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: PieChart(
//                     PieChartData(
//                       sections: List.generate(sortedEntries.length, (i) {
//                         final entry = sortedEntries[i];
//                         final percentage = (entry.value / totalSpent) * 100;
//                         return PieChartSectionData(
//                           value: entry.value,
//                           title:
//                               "${entry.key}\n${percentage.toStringAsFixed(1)}%",
//                           color: colors[i],
//                           radius: 90,
//                           titleStyle: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         );
//                       }),
//                       sectionsSpace: 2,
//                       centerSpaceRadius: 0,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Divider(),
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Total Spent: ",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "₱${totalSpent.toStringAsFixed(2)}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
