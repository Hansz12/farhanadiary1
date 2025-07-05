import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'theme_provider.dart';
import 'add_entry_screen.dart';
import 'diary_entry.dart';
import 'shared_pref_service.dart';
import 'entry_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DiaryEntry> allEntries = [];
  List<DiaryEntry> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    loadUsername();
    loadEntries();
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> loadEntries() async {
    allEntries = await SharedPrefService.getEntries();
    filterEntries();
  }

  void filterEntries() {
    final selected = _selectedDay ?? DateTime.now();
    final filtered = allEntries.where((entry) =>
        entry.date.year == selected.year &&
        entry.date.month == selected.month &&
        entry.date.day == selected.day).toList();

    setState(() {
      filteredEntries = filtered;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $username 💜'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                filterEntries();
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredEntries.isEmpty
                ? const Center(child: Text("No notes for this day 🥲"))
                : ListView.builder(
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      final actualIndex = allEntries.indexOf(entry);

                      return EntryCard(
                        entry: entry,
                        index: actualIndex,
                        onDelete: () {
                          setState(() {
                            allEntries.removeAt(actualIndex);
                            filterEntries();
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          );
          await loadEntries(); // refresh after return
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
