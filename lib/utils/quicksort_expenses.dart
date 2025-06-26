import '../models/expense.dart';

enum SortBy { cost, importance, date }

List<Expense> quickSortExpenses(List<Expense> expenses, SortBy sortBy, {bool descending = true}) {
  if (expenses.length <= 1) return expenses;

  final pivot = expenses[0];
  final less = <Expense>[];
  final greater = <Expense>[];

  for (int i = 1; i < expenses.length; i++) {
    final comparison = _compare(expenses[i], pivot, sortBy);
    if (descending ? comparison > 0 : comparison < 0) {
      greater.add(expenses[i]);
    } else {
      less.add(expenses[i]);
    }
  }

  return [
    ...quickSortExpenses(greater, sortBy, descending: descending),
    pivot,
    ...quickSortExpenses(less, sortBy, descending: descending),
  ];
}

int _compare(Expense a, Expense b, SortBy sortBy) {
  switch (sortBy) {
    case SortBy.cost:
      return a.cost.compareTo(b.cost);
    case SortBy.importance:
      return a.importance.compareTo(b.importance);
    case SortBy.date:
      return a.date.compareTo(b.date);
  }
}
