import 'package:flutter/material.dart';
import 'main_menu_page.dart';
// import 'records_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _accepted = false;

  void _proceed() {
    if (_accepted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainMenuPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the terms to continue.")),
      );
    }
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Terms and Conditions"),
        content: const Text("uhhhhhhhhhhhhhhhhhhhhhhhhhhh."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Centsible!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showTerms,
                child: const Text("View Terms & Conditions"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _accepted,
                    onChanged: (val) => setState(() => _accepted = val ?? false),
                  ),
                  const Text("I accept the terms."),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accepted ? Colors.black87 : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Let’s Get Started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
