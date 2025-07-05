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
  DateTime selectedDate = DateTime.now();
  List<DiaryEntry> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    groupedEntries = {};
    loadEntries();
  }

  DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> loadEntries() async {
    final entries = await SharedPrefService.getEntries();
    setState(() {
      groupedEntries = {};
      for (var entry in entries) {
        final dateKey = normalizeDate(entry.date);
        groupedEntries.putIfAbsent(dateKey, () => []).add(entry);
      }
      filteredEntries = groupedEntries[normalizeDate(selectedDate)] ?? [];
    });
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    final normalizedDay = normalizeDate(day);
    setState(() {
      selectedDate = normalizedDay;
      filteredEntries = groupedEntries[normalizedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar 🗓️',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
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
              weekendTextStyle: TextStyle(
                color: isDark ? Colors.red.shade200 : Colors.red,
              ),
              defaultTextStyle: GoogleFonts.poppins(),
              todayTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              formatButtonVisible: false,
              titleCentered: true,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: GoogleFonts.poppins(color: Colors.red),
              weekdayStyle: GoogleFonts.poppins(),
            ),
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: onDaySelected,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredEntries.isEmpty
                ? Center(
                    child: Text(
                      "No entry on this date 😅",
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: theme.cardColor,
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Text(
                            entry.emoji,
                            style: const TextStyle(
                              fontSize: 28,
                              fontFamilyFallback: [
                                'NotoColorEmoji',
                                'Segoe UI Emoji',
                                'Apple Color Emoji'
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
