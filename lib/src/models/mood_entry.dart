class MoodEntry {
  final String emoji;
  final String mood;
  final String? note;
  final DateTime timestamp;

  MoodEntry({
    required this.emoji,
    required this.mood,
    this.note,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Konvertiere zu Map für SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'mood': mood,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Erstelle MoodEntry aus Map
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      emoji: json['emoji'] as String,
      mood: json['mood'] as String,
      note: json['note'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
