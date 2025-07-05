import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diary_entry.dart';

class SharedPrefService {
  static const String _entryKey = 'diary_entries';

  // Save a new diary entry
  static Future<void> saveEntry(DiaryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesList = await getEntries();
    entriesList.add(entry);
    final encoded = jsonEncode(entriesList.map((e) => e.toJson()).toList());
    await prefs.setString(_entryKey, encoded);
  }

  // Read all saved diary entries
  static Future<List<DiaryEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_entryKey);
    if (encoded == null || encoded.isEmpty) return [];
    try {
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded.map((e) => DiaryEntry.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error decoding diary entries: $e");
      return [];
    }
  }

  // Update a diary entry at a specific index
  static Future<void> updateEntry(int index, DiaryEntry updatedEntry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    if (index >= 0 && index < entries.length) {
      entries[index] = updatedEntry;
      final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString(_entryKey, encoded);
    }
  }

  // Delete entry at index
  static Future<void> deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    if (index >= 0 && index < entries.length) {
      entries.removeAt(index);
      final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString(_entryKey, encoded);
    }
  }

  // Clear all saved entries
  static Future<void> clearAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_entryKey);
  }
}
