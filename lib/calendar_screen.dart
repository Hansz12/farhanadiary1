import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'diary_entry.dart';
import 'shared_pref_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<DiaryEntry>> groupedEntries;
  DateTime selectedDate = _normalizeDate(DateTime.now());
  List<DiaryEntry> filteredEntries = [];

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    groupedEntries = {};
    loadEntries();
  }

  Future<void> loadEntries() async {
    final entries = await SharedPrefService.getEntries();
    final Map<DateTime, List<DiaryEntry>> tempGrouped = {};

    for (var entry in entries) {
      final dateKey = _normalizeDate(entry.date);
      tempGrouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    setState(() {
      groupedEntries = tempGrouped;
      filteredEntries = groupedEntries[selectedDate] ?? [];
    });
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    final normalizedDay = _normalizeDate(day);
    setState(() {
      selectedDate = normalizedDay;
      filteredEntries = groupedEntries[normalizedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalender 🗓️',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDate,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.purple.shade200,
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: onDaySelected,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredEntries.isEmpty
                ? Center(
                    child: Text(
                      "Tiada entri pada tarikh ini 😅",
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      return ListTile(
                        leading: Text(
                          entry.emoji,
                          style: const TextStyle(
                            fontSize: 28,
                            fontFamilyFallback: [
                              'NotoColorEmoji',
                              'Segoe UI Emoji',
                              'Apple Color Emoji',
                            ],
                          ),
                        ),
                        title: Text(
                          entry.title,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          entry.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
