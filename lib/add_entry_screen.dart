import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'diary_entry.dart';
import 'shared_pref_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedEmoji = '😊';

  final List<String> emojiList = [
    '😊', '😢', '❤️', '😎', '😭', '💜', '😡', '🥰', '🎉', '😴',
    '😇', '🙃', '🥺', '🤔', '😤', '🤩', '🫣', '🤯', '💩', '👍',
  ];

  void saveEntry() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tajuk & kandungan tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newEntry = DiaryEntry(
      title: title,
      content: content,
      emoji: selectedEmoji,
      date: DateTime.now(),
    );

    await SharedPrefService.saveEntry(newEntry);

    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget buildEmojiGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: emojiList.map((emoji) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedEmoji = emoji;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedEmoji == emoji
                  ? Colors.purple.shade100
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 24,
                fontFamilyFallback: [
                  'NotoColorEmoji',
                  'Segoe UI Emoji',
                  'Apple Color Emoji',
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Nota 📝",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tajuk',
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Kandungan',
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            Text(
              "Pilih Emoji:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            buildEmojiGrid(),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: saveEntry,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
