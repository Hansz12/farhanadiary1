import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'diary_entry.dart';
import 'shared_pref_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<DiaryEntry>> dailyEntries;
  DateTime selectedDate = _normalizeDate(DateTime.now());
  List<DiaryEntry> entriesForDay = [];

  // Normalize DateTime to remove time component
  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    dailyEntries = {};
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await SharedPrefService.getEntries();
    Map<DateTime, List<DiaryEntry>> map = {};

    for (var entry in entries) {
      final dateKey = _normalizeDate(entry.date);
      map.putIfAbsent(dateKey, () => []).add(entry);
    }

    setState(() {
      dailyEntries = map;
      entriesForDay = dailyEntries[selectedDate] ?? [];
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    final normalized = _normalizeDate(day);
    setState(() {
      selectedDate = normalized;
      entriesForDay = dailyEntries[normalized] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar 🗓️',
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
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: entriesForDay.isEmpty
                ? Center(
                    child: Text(
                      "No entries for this day 😊",
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : ListView.builder(
                    itemCount: entriesForDay.length,
                    itemBuilder: (context, index) {
                      final entry = entriesForDay[index];
                      return ListTile(
                        leading: Text(
                          entry.emoji,
                          style: const TextStyle(fontSize: 28),
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
