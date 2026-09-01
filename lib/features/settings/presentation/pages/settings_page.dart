import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../notifications/data/services/reminder_notification_service.dart';
import '../../../streaks/presentation/providers/streak_provider.dart';
import '../../../todos/presentation/providers/todo_provider.dart';
import '../../data/models/app_settings.dart';
import '../../data/services/haptics_service.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _busy = false;
  bool _permissionDenied = false;

  Future<void> _run(Future<void> Function() action, {String? success}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && success != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(success)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setNotifications(bool enabled, AppSettings settings) async {
    await _run(() async {
      final service = ReminderNotificationService.instance;
      if (!enabled) {
        service.configureGlobalEnabled(false);
        await service.clearAllNotifications();
        await ref.read(settingsRepositoryProvider).updateNotifications(false);
        await HapticsService.selection(enabled: settings.hapticsEnabled);
        if (mounted) setState(() => _permissionDenied = false);
        return;
      }

      final granted = await service.requestPermission();
      if (!granted) {
        await ref.read(settingsRepositoryProvider).updateNotifications(false);
        if (mounted) setState(() => _permissionDenied = true);
        return;
      }

      service.configureGlobalEnabled(true);
      await ref.read(settingsRepositoryProvider).updateNotifications(true);
      final streaks = await ref.read(streakRepositoryProvider).getAll();
      final todos = await ref.read(todoRepositoryProvider).getAll();
      for (final streak in streaks) {
        await service.syncStreakReminders(streak);
      }
      for (final todo in todos) {
        if (todo.id != null) {
          await service.syncTodoReminder(
            todoId: todo.id!,
            title: todo.title,
            reminderEnabled: todo.reminderEnabled,
            isCompleted: todo.isCompleted,
            reminderAt: todo.reminderAt,
          );
        }
      }
      if (mounted) setState(() => _permissionDenied = false);
      await HapticsService.success(enabled: settings.hapticsEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _SettingsError(
          error: error,
          onRetry: () => ref.invalidate(appSettingsProvider),
        ),
        data: (settings) => Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Text('Make Streak yours',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  'Choose how the app looks, feels, and keeps you on track.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                const _SectionTitle('Appearance'),
                _SettingsCard(
                  children: [
                    _IconHeader(
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle:
                          'Follow your device or choose a fixed appearance.',
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: SegmentedButton<AppThemeMode>(
                        segments: const [
                          ButtonSegment(
                              value: AppThemeMode.system,
                              icon: Icon(Icons.settings_suggest_outlined),
                              label: Text('System')),
                          ButtonSegment(
                              value: AppThemeMode.light,
                              icon: Icon(Icons.light_mode_outlined),
                              label: Text('Light')),
                          ButtonSegment(
                              value: AppThemeMode.dark,
                              icon: Icon(Icons.dark_mode_outlined),
                              label: Text('Dark')),
                        ],
                        selected: {settings.themeMode},
                        showSelectedIcon: false,
                        onSelectionChanged: _busy
                            ? null
                            : (selection) => _run(() async {
                                  await ref
                                      .read(settingsRepositoryProvider)
                                      .updateThemeMode(selection.first);
                                  await HapticsService.selection(
                                      enabled: settings.hapticsEnabled);
                                }),
                      ),
                    ),
                  ],
                ),
                const _SectionTitle('Notifications & feedback'),
                _SettingsCard(
                  children: [
                    SwitchListTile.adaptive(
                      secondary:
                          const _LeadingIcon(Icons.notifications_outlined),
                      title: const Text('Notifications enabled'),
                      subtitle: const Text(
                          'Allow reminders for streaks and to-do items.'),
                      value: settings.notificationsEnabled,
                      onChanged: _busy
                          ? null
                          : (value) => _setNotifications(value, settings),
                    ),
                    if (_permissionDenied)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Material(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        'Notifications are blocked by your device settings.',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onErrorContainer))),
                                TextButton(
                                  onPressed: ReminderNotificationService
                                      .instance.openSystemNotificationSettings,
                                  child: const Text('Open settings'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      secondary: const _LeadingIcon(Icons.vibration_outlined),
                      title: const Text('Haptics enabled'),
                      subtitle:
                          const Text('Feel feedback for meaningful actions.'),
                      value: settings.hapticsEnabled,
                      onChanged: _busy
                          ? null
                          : (value) => _run(() async {
                                await ref
                                    .read(settingsRepositoryProvider)
                                    .updateHaptics(value);
                                await HapticsService.selection(enabled: value);
                              }),
                    ),
                  ],
                ),
                const _SectionTitle('Your data'),
                _SettingsCard(
                  children: [
                    ListTile(
                      leading: const _LeadingIcon(Icons.ios_share_outlined),
                      title: const Text('Export data'),
                      subtitle: const Text(
                          'Share a readable JSON copy of everything stored locally.'),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: !_busy,
                      onTap: () => _run(
                          ref.read(dataManagementServiceProvider).exportData,
                          success: 'Export ready to share.'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const _LeadingIcon(Icons.restart_alt),
                      title: const Text('Reset activity'),
                      subtitle: const Text(
                          'Erase streaks, tasks, and awards but keep preferences.'),
                      enabled: !_busy,
                      onTap: () => _confirmActivityReset(settings),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: _LeadingIcon(Icons.delete_forever_outlined,
                          color: Theme.of(context).colorScheme.error),
                      title: Text('Factory reset',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                      subtitle: const Text(
                          'Erase all data and restore default settings.'),
                      enabled: !_busy,
                      onTap: () => _confirmFactoryReset(settings),
                    ),
                  ],
                ),
                const _SectionTitle('About'),
                _SettingsCard(
                  children: [
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final info = snapshot.data;
                        return ListTile(
                          leading: const _LeadingIcon(
                              Icons.local_fire_department_outlined),
                          title: const Text('Streak App'),
                          subtitle: Text(info == null
                              ? 'Version information'
                              : 'Version ${info.version} (${info.buildNumber})'),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: _LeadingIcon(Icons.lock_outline),
                      title: Text('Private by default'),
                      subtitle: Text(
                          'Your streaks and preferences are stored locally on this device.'),
                    ),
                  ],
                ),
              ],
            ),
            if (_busy)
              const Positioned(
                  top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmActivityReset(AppSettings settings) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset activity?'),
        content: const Text(
            'This permanently deletes all streaks, completions, tasks, and awards. Your preferences stay unchanged.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset activity')),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(() async {
        await ref.read(dataManagementServiceProvider).resetActivity();
        await HapticsService.destructive(enabled: settings.hapticsEnabled);
      }, success: 'Activity data was reset.');
    }
  }

  Future<void> _confirmFactoryReset(AppSettings settings) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Factory reset?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'This permanently erases all app data. Type RESET to continue.'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Confirmation'),
                onChanged: (_) => setDialogState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: controller.text == 'RESET'
                  ? () => Navigator.pop(dialogContext, true)
                  : null,
              child: const Text('Factory reset'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (confirmed == true) {
      await _run(() async {
        await HapticsService.destructive(enabled: settings.hapticsEnabled);
        await ref.read(dataManagementServiceProvider).factoryReset();
      }, success: 'Streak App was reset.');
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Text(label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700)),
      );
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      );
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon(this.icon, {this.color});
  final IconData icon;
  final Color? color;
  @override
  Widget build(BuildContext context) => CircleAvatar(
        backgroundColor: (color ?? Theme.of(context).colorScheme.primary)
            .withValues(alpha: .12),
        foregroundColor: color ?? Theme.of(context).colorScheme.primary,
        child: Icon(icon, size: 21),
      );
}

class _IconHeader extends StatelessWidget {
  const _IconHeader(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => ListTile(
        leading: _LeadingIcon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      );
}

class _SettingsError extends StatelessWidget {
  const _SettingsError({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40),
              const SizedBox(height: 12),
              Text('Unable to load settings',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again')),
            ],
          ),
        ),
      );
}
