import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'change_pin_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tetapan ⚙️",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.purple),
            title: Text(
              'Tukar PIN',
              style: GoogleFonts.poppins(),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePinScreen()),
              );
            },
          ),
          const Divider(),
          // Tambahan lain (logout, ganti tema dsb)
        ],
      ),
    );
  }
}
