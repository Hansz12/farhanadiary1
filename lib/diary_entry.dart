class DiaryEntry {
  final String title;
  final String content;
  final DateTime date;
  final String emoji;

  DiaryEntry({
    required this.title,
    required this.content,
    required this.date,
    required this.emoji,
  });

  // Convert object to JSON (untuk simpan dalam SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'emoji': emoji,
    };
  }

  // Convert JSON to object (bila baca balik dari SharedPreferences)
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      emoji: json['emoji'],
    );
  }
}
