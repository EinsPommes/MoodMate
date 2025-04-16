import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';
import 'thank_you_screen.dart';

class NoteScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final noteController = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(mood),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: noteController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Möchtest du etwas dazu sagen?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () async {
                        final entry = MoodEntry(
                          emoji: emoji,
                          mood: mood,
                          note: noteController.text.trim(),
                        );
                        await storage.saveMoodEntry(entry);

                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const ThankYouScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Speichern'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
