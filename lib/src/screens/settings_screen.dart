import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  final StorageService storage;

  const SettingsScreen({
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
              title: Text('Einstellungen'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.dark_mode_outlined),
                            title: const Text('Dark Mode'),
                            trailing: Switch(
                              value: Theme.of(context).brightness == Brightness.dark,
                              onChanged: (_) {
                                // TODO: Implement dark mode toggle
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.delete_outline,
                              color: colorScheme.error,
                            ),
                            title: Text(
                              'Verlauf löschen',
                              style: TextStyle(
                                color: colorScheme.error,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Verlauf löschen'),
                                  content: const Text(
                                    'Möchtest du wirklich deinen gesamten Verlauf löschen?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Abbrechen'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        storage.clearMoodEntries();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Verlauf wurde gelöscht'),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Löschen',
                                        style: TextStyle(
                                          color: colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      return Center(
                        child: Text(
                          'Version ${snapshot.data!.version}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
