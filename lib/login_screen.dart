import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    checkIfFirstTime();
  }

  Future<void> checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('user_pin');
    String? savedUsername = prefs.getString('username');

    setState(() {
      isFirstTime = savedPin == null || savedUsername == null;
    });
  }

  void handleLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pin = _pinController.text.trim();
    String username = _usernameController.text.trim();

    if (pin.length != 4 || username.isEmpty) {
      if (!mounted) return;
      showError("Please enter username and 4-digit PIN");
      return;
    }

    if (isFirstTime) {
      // Register
      await prefs.setString('username', username);
      await prefs.setString('user_pin', pin);
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Login
      String savedUsername = prefs.getString('username') ?? '';
      String savedPin = prefs.getString('user_pin') ?? '';

      if (username == savedUsername && pin == savedPin) {
        await prefs.setBool('isLoggedIn', true);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        if (!mounted) return;
        showError("Username or PIN is incorrect");
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 100, color: Colors.purple),
              const SizedBox(height: 20),
              Text(
                isFirstTime
                    ? "Register Username & PIN 🔐"
                    : "Login with Username & PIN",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 30),

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username 💁‍♀️',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // PIN Field
              TextField(
                controller: _pinController,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '4-digit PIN 🔢',
                  counterText: "",
                  prefixIcon: const Icon(Icons.pin, color: Colors.purple),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  isFirstTime ? "Register" : "Login",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
