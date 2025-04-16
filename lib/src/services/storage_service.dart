import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class StorageService {
  final SharedPreferences prefs;
  static const String _entriesKey = 'mood_entries';

  StorageService(this.prefs);

  // Speichere einen neuen Eintrag
  Future<void> saveMoodEntry(MoodEntry entry) async {
    final entries = await getMoodEntries();
    entries.add(entry);
    
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_entriesKey, jsonEncode(jsonList));
  }

  // Hole alle Einträge
  Future<List<MoodEntry>> getMoodEntries() async {
    final jsonString = prefs.getString(_entriesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => MoodEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Bei Fehler (z.B. ungültiges Format) leere Liste zurückgeben
      await prefs.remove(_entriesKey);
      return [];
    }
  }

  // Lösche alle Einträge (für Tests)
  Future<void> clearEntries() async {
    await prefs.remove(_entriesKey);
  }

  Future<void> clearMoodEntries() async {
    await prefs.remove(_entriesKey);
  }
}
