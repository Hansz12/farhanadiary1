import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final oldPinController = TextEditingController();
  final newPinController = TextEditingController();

  String? errorMessage;
  String? successMessage;

  Future<void> changePin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('userPin') ?? '';

    final oldPin = oldPinController.text.trim();
    final newPin = newPinController.text.trim();

    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    if (oldPin.isEmpty || newPin.isEmpty) {
      setState(() {
        errorMessage = "PIN cannot be empty.";
      });
      return;
    }

    if (oldPin != storedPin) {
      setState(() {
        errorMessage = "Old PIN is incorrect.";
      });
      return;
    }

    await prefs.setString('userPin', newPin);
    setState(() {
      successMessage = "PIN changed successfully! 🎉";
      oldPinController.clear();
      newPinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change PIN 🔐",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: oldPinController,
              decoration: const InputDecoration(
                labelText: 'Old PIN',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPinController,
              decoration: const InputDecoration(
                labelText: 'New PIN',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: changePin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Change PIN'),
            ),
            const SizedBox(height: 12),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (successMessage != null)
              Text(
                successMessage!,
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
