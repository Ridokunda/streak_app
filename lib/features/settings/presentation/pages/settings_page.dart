import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final repository = ref.watch(settingsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load settings: $error')),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Preferences',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Customize the app behavior and notifications.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text('Dark mode'),
                      subtitle: const Text('Use dark theme throughout the app.'),
                      value: settings.darkMode,
                      onChanged: (value) => repository.updateDarkMode(value),
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      title: const Text('Notifications enabled'),
                      subtitle: const Text('Allow reminder and streak notifications.'),
                      value: settings.notificationsEnabled,
                      onChanged: (value) => repository.updateNotifications(value),
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      title: const Text('Haptics enabled'),
                      subtitle: const Text('Vibrate for supported interactions.'),
                      value: settings.hapticsEnabled,
                      onChanged: (value) => repository.updateHaptics(value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  subtitle: const Text('Streak App settings are stored locally on your device.'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
