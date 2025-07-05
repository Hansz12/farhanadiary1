import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'diary_entry.dart';
import 'shared_pref_service.dart';

class EditEntryScreen extends StatefulWidget {
  final int index;
  final DiaryEntry entry;

  const EditEntryScreen({super.key, required this.index, required this.entry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String selectedEmoji;

  final List<String> emojiList = [
    '😊', '😢', '❤️', '😎', '😭', '💜', '😡', '🥰', '🎉', '😴',
    '😇', '🙃', '🥺', '🤔', '😤', '🤩', '🫣', '🤯', '💩', '👍',
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.entry.title);
    contentController = TextEditingController(text: widget.entry.content);
    selectedEmoji = widget.entry.emoji;
  }

  void updateEntry() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and content cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedEntry = DiaryEntry(
      title: title,
      content: content,
      emoji: selectedEmoji,
      date: DateTime.now(),
    );

    await SharedPrefService.updateEntry(widget.index, updatedEntry);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget buildEmojiGrid() {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: emojiList.map((emoji) {
        final isSelected = emoji == selectedEmoji;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedEmoji = emoji;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withAlpha(25) // 0.1 opacity
                  : theme.cardColor,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(77), // 0.3 opacity
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 24,
                fontFamilyFallback: [
                  'NotoColorEmoji',
                  'Segoe UI Emoji',
                  'Apple Color Emoji'
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Entry ✏️',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Choose Emoji:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            buildEmojiGrid(),
            const SizedBox(height: 40),
            Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                onPressed: updateEntry,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                label: const Text('Save Changes'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
