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
              title: Text('Wie geht es dir?'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate([
                  _MoodButton(
                    mood: 'Fantastisch',
                    emoji: '🤩',
                    color: const Color(0xFFFFC107), // Amber
                    onTap: () => _onMoodSelected(context, 'Fantastisch', '🤩'),
                  ),
                  _MoodButton(
                    mood: 'Sehr gut',
                    emoji: '😄',
                    color: const Color(0xFF8BC34A), // Light Green
                    onTap: () => _onMoodSelected(context, 'Sehr gut', '😄'),
                  ),
                  _MoodButton(
                    mood: 'Gut',
                    emoji: '🙂',
                    color: const Color(0xFF03A9F4), // Light Blue
                    onTap: () => _onMoodSelected(context, 'Gut', '🙂'),
                  ),
                  _MoodButton(
                    mood: 'Okay',
                    emoji: '😐',
                    color: const Color(0xFFFF9800), // Orange
                    onTap: () => _onMoodSelected(context, 'Okay', '😐'),
                  ),
                  _MoodButton(
                    mood: 'Nicht so gut',
                    emoji: '😢',
                    color: const Color(0xFFFF5252), // Red Accent
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
  final String mood;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _MoodButton({
    required this.mood,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(isDark ? 0.2 : 0.1),
                color.withOpacity(isDark ? 0.1 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                mood,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
