import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import 'diary_entry.dart';
import 'shared_pref_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();
  final emojiParser = EmojiParser();

  void saveEntry() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    String emoji = _emojiController.text.trim();
    DateTime date = DateTime.now();

    if (title.isEmpty || content.isEmpty || emoji.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newEntry = DiaryEntry(
      title: title,
      content: content,
      emoji: emoji,
      date: date,
    );

    await SharedPrefService.addEntry(newEntry);
    Navigator.pop(context); // Balik ke home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Entry ✍️'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Note',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emojiController,
                decoration: InputDecoration(
                  labelText: 'Emoji (e.g. 😊)',
                  prefixIcon: const Icon(Icons.emoji_emotions),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: saveEntry,
                icon: const Icon(Icons.save),
                label: const Text('Save Entry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
