import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/mood_entry.dart';

class StatsScreen extends StatelessWidget {
  final StorageService storage;

  const StatsScreen({
    super.key,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text('Stimmungs-Statistik'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: FutureBuilder<List<MoodEntry>>(
                  future: storage.getMoodEntries(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final entries = snapshot.data!;
                    if (entries.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.analytics_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Noch keine Einträge vorhanden',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Gruppiere Einträge nach Monat
                    final now = DateTime.now();
                    final thisMonth = DateTime(now.year, now.month);
                    final lastMonth = DateTime(now.year, now.month - 1);

                    final thisMonthEntries = entries.where((entry) {
                      final entryDate = DateTime(
                        entry.date.year,
                        entry.date.month,
                      );
                      return entryDate == thisMonth;
                    }).toList();

                    final lastMonthEntries = entries.where((entry) {
                      final entryDate = DateTime(
                        entry.date.year,
                        entry.date.month,
                      );
                      return entryDate == lastMonth;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMonthStats(
                          context,
                          'Dieser Monat',
                          thisMonthEntries,
                          colorScheme,
                          textTheme,
                        ),
                        const SizedBox(height: 32),
                        _buildMonthStats(
                          context,
                          'Letzter Monat',
                          lastMonthEntries,
                          colorScheme,
                          textTheme,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthStats(
    BuildContext context,
    String title,
    List<MoodEntry> entries,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (entries.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Keine Einträge',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      );
    }

    // Zähle die Häufigkeit jeder Stimmung
    final moodCounts = <String, int>{};
    for (final entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    // Sortiere die Stimmungen nach ihrer vordefinierten Reihenfolge
    final sortedMoods = [
      'Fantastisch',
      'Sehr gut',
      'Gut',
      'Okay',
      'Nicht so gut',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final mood in sortedMoods)
                  if (moodCounts.containsKey(mood)) ...[
                    _MoodStatBar(
                      emoji: _getEmojiForMood(mood),
                      mood: mood,
                      count: moodCounts[mood]!,
                      total: entries.length,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getEmojiForMood(String mood) {
    switch (mood) {
      case 'Fantastisch':
        return '🤩';
      case 'Sehr gut':
        return '😄';
      case 'Gut':
        return '🙂';
      case 'Okay':
        return '😐';
      case 'Nicht so gut':
        return '😢';
      default:
        return '❓';
    }
  }
}

class _MoodStatBar extends StatelessWidget {
  final String emoji;
  final String mood;
  final int count;
  final int total;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _MoodStatBar({
    required this.emoji,
    required this.mood,
    required this.count,
    required this.total,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = count / total;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    Color getColorForMood() {
      switch (mood) {
        case 'Fantastisch':
          return const Color(0xFFFFC107); // Amber
        case 'Sehr gut':
          return const Color(0xFF8BC34A); // Light Green
        case 'Gut':
          return const Color(0xFF03A9F4); // Light Blue
        case 'Okay':
          return const Color(0xFFFF9800); // Orange
        case 'Nicht so gut':
          return const Color(0xFFFF5252); // Red Accent
        default:
          return Colors.grey;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$mood ($count×)',
                style: textTheme.bodyMedium,
              ),
            ),
            Text(
              '${(percentage * 100).round()}%',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: getColorForMood().withOpacity(isDark ? 0.2 : 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              getColorForMood().withOpacity(isDark ? 0.8 : 1),
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
