import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'diary_entry.dart';

class SharedPrefService {
  static const String _key = 'diary_entries';

  // Simpan semua nota
  static Future<void> saveEntries(List<DiaryEntry> entries) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedEntries = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encodedEntries);
  }

  // Ambil semua nota
  static Future<List<DiaryEntry>> getEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedEntries = prefs.getStringList(_key);

    if (encodedEntries == null) return [];

    return encodedEntries
        .map((entry) => DiaryEntry.fromJson(jsonDecode(entry)))
        .toList();
  }

  // Padam nota ikut index
  static Future<void> deleteEntry(int index) async {
    List<DiaryEntry> entries = await getEntries();
    if (index >= 0 && index < entries.length) {
      entries.removeAt(index);
      await saveEntries(entries);
    }
  }

  // Tambah nota baru
  static Future<void> addEntry(DiaryEntry entry) async {
    List<DiaryEntry> entries = await getEntries();
    entries.add(entry);
    await saveEntries(entries);
  }
}
