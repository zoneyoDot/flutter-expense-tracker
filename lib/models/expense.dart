import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double cost;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final int importance;

  Expense({
    required this.category,
    required this.cost,
    required this.date,
    required this.importance,
  });
}
