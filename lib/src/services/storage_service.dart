import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class StorageService {
  static const String _key = 'mood_entries';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Speichere einen neuen Eintrag
  Future<void> saveMoodEntry(MoodEntry entry) async {
    final entries = await getMoodEntries();
    entries.insert(0, entry); // Neuster Eintrag zuerst
    
    final jsonList = entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }

  // Hole alle Einträge
  Future<List<MoodEntry>> getMoodEntries() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => MoodEntry.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Lösche alle Einträge (für Tests)
  Future<void> clearEntries() async {
    await _prefs.remove(_key);
  }

  Future<void> clearMoodEntries() async {
    await _prefs.remove(_key);
  }
}
