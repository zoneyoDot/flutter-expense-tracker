// lib/models/settings.dart
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  @HiveField(0)
  double weeklyBudget;

  Settings({required this.weeklyBudget});
}
