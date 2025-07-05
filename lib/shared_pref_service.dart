import 'dart:convert';
import 'package:flutter/foundation.dart'; // <-- untuk debugPrint
import 'package:shared_preferences/shared_preferences.dart';
import 'diary_entry.dart';

class SharedPrefService {
  static const String _entryKey = 'diary_entries';

  // Simpan entry baru
  static Future<void> saveEntry(DiaryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();

    entries.add(entry);

    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_entryKey, encoded);
  }

  // Ambil semua entry
  static Future<List<DiaryEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_entryKey);

    if (encoded == null || encoded.isEmpty) return [];

    try {
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded
          .map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("❌ Error decode entry: $e");
      return [];
    }
  }

  // Padam entry ikut index
  static Future<void> deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();

    if (index >= 0 && index < entries.length) {
      entries.removeAt(index);
      final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString(_entryKey, encoded);
    }
  }

  // Padam semua
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_entryKey);
  }
}
