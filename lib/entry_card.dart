import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'diary_entry.dart';
import 'shared_pref_service.dart';

class EntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final int index;
  final VoidCallback onDelete;

  const EntryCard({
    super.key,
    required this.entry,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(entry.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Text(
          entry.emoji,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(
          entry.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(entry.content),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await SharedPrefService.deleteEntry(index);
            onDelete();
          },
        ),
      ),
    );
  }
}
