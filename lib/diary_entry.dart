class DiaryEntry {
  final String title;
  final String content;
  final String emoji;
  final DateTime date;

  DiaryEntry({
    required this.title,
    required this.content,
    required this.emoji,
    required this.date,
  });

  // Convert object to JSON map
  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'emoji': emoji,
        'date': date.toIso8601String(),
      };

  // Convert JSON map back to object
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      title: json['title'],
      content: json['content'],
      emoji: json['emoji'],
      date: DateTime.parse(json['date']),
    );
  }
}
