import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../achievements/domain/achievement_catalog.dart';
import '../../../../core/enums/frequency.dart';
import '../../data/models/completion.dart';
import '../../data/models/monthly_completion_summary.dart';
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
  late Future<MonthlyCompletionSummary> _monthlySummaryFuture;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _loadData();
  }

  void _loadData() {
    final repository = ref.read(streakRepositoryProvider);
    _streakFuture = repository.getById(widget.streakId);
    _completionFuture = repository.getCompletionsForStreak(widget.streakId);
    _monthlySummaryFuture = repository.getMonthlyCompletionSummary(widget.streakId, _selectedMonth);
  }

  void _changeSelectedMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + offset);
      final repository = ref.read(streakRepositoryProvider);
      _monthlySummaryFuture = repository.getMonthlyCompletionSummary(widget.streakId, _selectedMonth);
    });
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

  List<Widget> _buildCalendarCells(MonthlyCompletionSummary summary) {
    final weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final firstDayOfMonth = DateTime(summary.month.year, summary.month.month, 1);
    final lastDayOfMonth = DateTime(summary.month.year, summary.month.month + 1, 0);
    final daysBeforeMonth = firstDayOfMonth.weekday % 7;
    final monthDates = List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(summary.month.year, summary.month.month, index + 1),
    );
    final completedSet = summary.completedDates
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet();

    final cells = <Widget>[];
    for (final label in weekdayLabels) {
      cells.add(
        Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    for (var i = 0; i < daysBeforeMonth; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (final date in monthDates) {
      final isCompleted = completedSet.contains(date);
      cells.add(
        Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green.shade100 : Colors.grey.shade100,
            border: Border.all(
              color: isCompleted ? Colors.green : Colors.grey.shade300,
              width: isCompleted ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.green.shade900 : Colors.grey.shade700,
            ),
          ),
        ),
      );
    }

    return cells;
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
              final badges = buildBadgesForStreak(streak);

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
                      if (badges.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: badges
                              .map(
                                (badge) => Chip(
                                  avatar: Icon(badge.icon, size: 16),
                                  label: Text(badge.title),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(label: 'Frequency', value: frequencyLabel),
                              _InfoRow(
                                label: 'Current streak',
                                value: '${streak.currentStreak} days',
                                valueIcon: Icons.local_fire_department,
                                valueIconColor: Colors.orange,
                              ),
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
                      FutureBuilder<MonthlyCompletionSummary>(
                        future: _monthlySummaryFuture,
                        builder: (context, summarySnapshot) {
                          final summary = summarySnapshot.data;

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Monthly completion',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        tooltip: 'Previous month',
                                        onPressed: () => _changeSelectedMonth(-1),
                                        icon: const Icon(Icons.chevron_left),
                                      ),
                                      Text(
                                        '${_selectedMonth.month}/${_selectedMonth.year}',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      IconButton(
                                        tooltip: 'Next month',
                                        onPressed: () => _changeSelectedMonth(1),
                                        icon: const Icon(Icons.chevron_right),
                                      ),
                                    ],
                                  ),
                                  if (summary == null)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                                  else ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '${summary.completedCount} completions',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${summary.completionRate.toStringAsFixed(1)}% complete',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    GridView.count(
                                      crossAxisCount: 7,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      mainAxisSpacing: 6,
                                      crossAxisSpacing: 6,
                                      childAspectRatio: 1,
                                      children: _buildCalendarCells(summary),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
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
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueIcon,
    this.valueIconColor,
  });

  final String label;
  final String value;
  final IconData? valueIcon;
  final Color? valueIconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (valueIcon != null) ...[
                Icon(
                  valueIcon,
                  size: 18,
                  color: valueIconColor ?? Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
              ],
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
