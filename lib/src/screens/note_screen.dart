import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import 'thank_you_screen.dart';

class NoteScreen extends StatefulWidget {
  final StorageService storage;
  final String mood;
  final String emoji;

  const NoteScreen({
    super.key,
    required this.storage,
    required this.mood,
    required this.emoji,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() async {
    final entry = MoodEntry(
      mood: widget.mood,
      emoji: widget.emoji,
      note: _controller.text.isEmpty ? null : _controller.text,
      date: DateTime.now(),
    );

    await widget.storage.saveMoodEntry(entry);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ThankYouScreen(
          mood: widget.mood,
          emoji: widget.emoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notiz hinzufügen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Möchtest du noch etwas zu deiner Stimmung notieren?',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _onSave,
              child: const Text('Speichern'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
