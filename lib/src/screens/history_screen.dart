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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_outlined,
                            size: 64,
                            color: Colors.black26,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Noch keine Einträge vorhanden',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final entries = snapshot.data!;
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MoodCard(entry: entry),
                        );
                      },
                      childCount: entries.length,
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
}

class _MoodCard extends StatelessWidget {
  final MoodEntry entry;

  const _MoodCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entry.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.mood,
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy HH:mm').format(entry.timestamp),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (entry.note != null && entry.note!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.note!,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
