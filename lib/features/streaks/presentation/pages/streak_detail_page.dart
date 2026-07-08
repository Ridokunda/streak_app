import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/frequency.dart';
import '../../data/models/completion.dart';
import '../../data/models/streak.dart';
import '../providers/streak_provider.dart';

class StreakDetailPage extends ConsumerStatefulWidget {
  const StreakDetailPage({super.key, required this.streakId});

  final int streakId;

  @override
  ConsumerState<StreakDetailPage> createState() => _StreakDetailPageState();
}

class _StreakDetailPageState extends ConsumerState<StreakDetailPage> {
  late Future<Streak?> _streakFuture;
  late Future<List<Completion>> _completionFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final repository = ref.read(streakRepositoryProvider);
    _streakFuture = repository.getById(widget.streakId);
    _completionFuture = repository.getCompletionsForStreak(widget.streakId);
  }

  Future<void> _markCompleted() async {
    final repository = ref.read(streakRepositoryProvider);
    await repository.markCompleted(widget.streakId);
    setState(_loadData);
  }

  Future<void> _deleteStreak() async {
    final repository = ref.read(streakRepositoryProvider);
    await repository.delete(widget.streakId);

    if (mounted) {
      context.pop();
    }
  }

  String _formatReminderMinutes(int totalMinutes) {
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    final time = TimeOfDay(hour: hour, minute: minute);
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  Future<void> _toggleReminders(Streak streak, bool enabled) async {
    final repository = ref.read(streakRepositoryProvider);
    streak.remindersEnabled = enabled;

    if (!enabled) {
      streak.reminderTimes = <int>[];
    }

    await repository.update(streak);
    setState(_loadData);
  }

  Future<void> _addReminderTime(Streak streak) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) {
      return;
    }

    final repository = ref.read(streakRepositoryProvider);
    final nextMinute = (picked.hour * 60) + picked.minute;
    final times = <int>{...streak.reminderTimes, nextMinute}.toList()..sort();
    streak.reminderTimes = times;
    streak.remindersEnabled = true;
    await repository.update(streak);
    setState(_loadData);
  }

  Future<void> _editReminderTime(Streak streak, int index) async {
    final current = streak.reminderTimes[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked == null) {
      return;
    }

    final repository = ref.read(streakRepositoryProvider);
    final updated = List<int>.from(streak.reminderTimes);
    updated[index] = (picked.hour * 60) + picked.minute;
    streak.reminderTimes = updated.toSet().toList()..sort();
    await repository.update(streak);
    setState(_loadData);
  }

  Future<void> _deleteReminderTime(Streak streak, int index) async {
    final repository = ref.read(streakRepositoryProvider);
    final updated = List<int>.from(streak.reminderTimes)..removeAt(index);
    streak.reminderTimes = updated;
    if (updated.isEmpty) {
      streak.remindersEnabled = false;
    }
    await repository.update(streak);
    setState(_loadData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Streak?>(
      future: _streakFuture,
      builder: (context, snapshot) {
        final streak = snapshot.data;
        final isTodayScheduled = streak == null
            ? false
            : (streak.frequency != Frequency.custom ||
                streak.scheduledDays.contains(DateTime.now().weekday));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Streak details'),
            actions: [
              IconButton(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_outlined),
                tooltip: 'Go to Home',
              ),
              IconButton(
                onPressed: _deleteStreak,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete streak',
              ),
            ],
          ),
          floatingActionButton: snapshot.connectionState == ConnectionState.done &&
                  streak != null &&
                  isTodayScheduled
              ? FloatingActionButton.extended(
                  onPressed: _markCompleted,
                  icon: const Icon(Icons.check),
                  label: const Text('Complete today'),
                )
              : null,
          body: Builder(
            builder: (context) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || streak == null) {
                return const Center(child: Text('Streak was not found.'));
              }

              final frequencyLabel = streak.frequency.name.toUpperCase();

              return FutureBuilder<List<Completion>>(
                future: _completionFuture,
                builder: (context, completionsSnapshot) {
                  if (completionsSnapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final completions = completionsSnapshot.data ?? <Completion>[];

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        streak.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        streak.description ?? 'No description provided.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(label: 'Frequency', value: frequencyLabel),
                              _InfoRow(label: 'Current streak', value: '${streak.currentStreak} days'),
                              _InfoRow(label: 'Best streak', value: '${streak.longestStreak} days'),
                              _InfoRow(label: 'Freezes', value: '${streak.freezeCount}'),
                              _InfoRow(
                                label: 'Reminders',
                                value: streak.remindersEnabled ? '${streak.reminderTimes.length}' : 'Off',
                              ),
                              _InfoRow(
                                label: 'Completed today',
                                value: completions.isNotEmpty &&
                                        completions.first.completedDate.year == DateTime.now().year &&
                                        completions.first.completedDate.month == DateTime.now().month &&
                                        completions.first.completedDate.day == DateTime.now().day
                                    ? 'Yes'
                                    : 'No',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Reminder notifications'),
                                subtitle: const Text('Enable reminder notifications for this streak.'),
                                value: streak.remindersEnabled,
                                onChanged: (value) => _toggleReminders(streak, value),
                              ),
                              if (streak.remindersEnabled) ...[
                                const SizedBox(height: 8),
                                if (streak.reminderTimes.isEmpty)
                                  const Text('No reminder times yet.')
                                else
                                  ...List.generate(streak.reminderTimes.length, (index) {
                                    final minutes = streak.reminderTimes[index];
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.notifications_active_outlined),
                                      title: Text(_formatReminderMinutes(minutes)),
                                      trailing: Wrap(
                                        spacing: 4,
                                        children: [
                                          IconButton(
                                            tooltip: 'Edit reminder time',
                                            onPressed: () => _editReminderTime(streak, index),
                                            icon: const Icon(Icons.edit_outlined),
                                          ),
                                          IconButton(
                                            tooltip: 'Delete reminder time',
                                            onPressed: () => _deleteReminderTime(streak, index),
                                            icon: const Icon(Icons.delete_outline),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                const SizedBox(height: 8),
                                OutlinedButton.icon(
                                  onPressed: () => _addReminderTime(streak),
                                  icon: const Icon(Icons.add_alarm),
                                  label: const Text('Add reminder time'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Recent completions', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      if (completions.isEmpty)
                        const Text('No completions yet.')
                      else
                        ...completions.map(
                          (completion) => ListTile(
                            leading: const Icon(Icons.check_circle),
                            title: Text(
                              '${completion.completedDate.day}/${completion.completedDate.month}/${completion.completedDate.year}',
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
