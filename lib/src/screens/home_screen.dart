import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'note_screen.dart';

class HomeScreen extends StatelessWidget {
  final StorageService storage;

  const HomeScreen({
    super.key,
    required this.storage,
  });

  void _onMoodSelected(BuildContext context, String mood, String emoji) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteScreen(
          storage: storage,
          mood: mood,
          emoji: emoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text('Wie fühlst du dich?'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate([
                  _MoodButton(
                    emoji: '🤩',
                    label: 'Fantastisch',
                    onTap: () => _onMoodSelected(context, 'Fantastisch', '🤩'),
                  ),
                  _MoodButton(
                    emoji: '😄',
                    label: 'Sehr gut',
                    onTap: () => _onMoodSelected(context, 'Sehr gut', '😄'),
                  ),
                  _MoodButton(
                    emoji: '🙂',
                    label: 'Gut',
                    onTap: () => _onMoodSelected(context, 'Gut', '🙂'),
                  ),
                  _MoodButton(
                    emoji: '😐',
                    label: 'Okay',
                    onTap: () => _onMoodSelected(context, 'Okay', '😐'),
                  ),
                  _MoodButton(
                    emoji: '😢',
                    label: 'Nicht so gut',
                    onTap: () => _onMoodSelected(context, 'Nicht so gut', '😢'),
                  ),
                ]),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
