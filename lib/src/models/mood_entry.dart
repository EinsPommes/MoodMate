class MoodEntry {
  final String mood;
  final String emoji;
  final String? note;
  final DateTime date;

  MoodEntry({
    required this.mood,
    required this.emoji,
    this.note,
    required this.date,
  });

  // Konvertiere zu Map für SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'emoji': emoji,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  // Erstelle MoodEntry aus Map
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      mood: json['mood'] as String,
      emoji: json['emoji'] as String,
      note: json['note'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
