import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatelessWidget {
  final StorageService storage;

  const HistoryScreen({
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
              title: Text('Verlauf'),
            ),
            FutureBuilder<List<MoodEntry>>(
              future: storage.getMoodEntries(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final entries = snapshot.data!;
                if (entries.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history_outlined,
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
                    ),
                  );
                }

                // Gruppiere Einträge nach Datum
                final groupedEntries = <DateTime, List<MoodEntry>>{};
                for (final entry in entries) {
                  final date = DateTime(
                    entry.date.year,
                    entry.date.month,
                    entry.date.day,
                  );
                  groupedEntries.putIfAbsent(date, () => []);
                  groupedEntries[date]!.add(entry);
                }

                final sortedDates = groupedEntries.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final date = sortedDates[index];
                        final dayEntries = groupedEntries[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                _formatDate(date),
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              child: Column(
                                children: [
                                  for (final entry in dayEntries) ...[
                                    ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          entry.emoji,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      title: Text(entry.mood),
                                      subtitle: entry.note != null
                                          ? Text(
                                              entry.note!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : null,
                                      trailing: Text(
                                        DateFormat.Hm().format(entry.date),
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                    ),
                                    if (entry != dayEntries.last)
                                      const Divider(height: 1),
                                  ],
                                ],
                              ),
                            ),
                            if (date != sortedDates.last)
                              const SizedBox(height: 16),
                          ],
                        );
                      },
                      childCount: sortedDates.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Heute';
    } else if (date == yesterday) {
      return 'Gestern';
    } else {
      return DateFormat.yMMMMd('de').format(date);
    }
  }
}
