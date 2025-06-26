import '../models/expense.dart';

List<Expense> knapsackExpenses(List<Expense> expenses, double budget) {
  int n = expenses.length;
  int W = (budget * 100).toInt(); // To avoid float issues (convert to centavos)

  List<List<int>> dp = List.generate(n + 1, (_) => List.filled(W + 1, 0));

  // Build DP table
  for (int i = 1; i <= n; i++) {
    int wt = (expenses[i - 1].cost * 100).toInt();
    int val = expenses[i - 1].importance;

    for (int w = 0; w <= W; w++) {
      if (wt > w) {
        dp[i][w] = dp[i - 1][w];
      } else {
        dp[i][w] =
            dp[i - 1][w]
                    .clamp(0, 1000000)
                    .toInt()
                    .compareTo(dp[i - 1][w - wt] + val) >
                0
            ? dp[i - 1][w]
            : dp[i - 1][w - wt] + val;
      }
    }
  }

  // Backtrack to find selected items
  List<Expense> selected = [];
  int w = W;
  for (int i = n; i > 0 && w >= 0; i--) {
    if (dp[i][w] != dp[i - 1][w]) {
      selected.add(expenses[i - 1]);
      w -= (expenses[i - 1].cost * 100).toInt();
    }
  }

  return selected;
}
