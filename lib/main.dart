import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/expense.dart';
// import 'pages/welcome_page.dart';
import 'models/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);

  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Settings>('settings');

  final settingsBox = Hive.box<Settings>('settings');
  if (settingsBox.get('user_settings') == null) {
    settingsBox.put('user_settings', Settings(weeklyBudget: 0));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centsible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFEEBE),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
