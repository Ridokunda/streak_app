import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak details'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _markCompleted,
        icon: const Icon(Icons.check),
        label: const Text('Complete today'),
      ),
      body: FutureBuilder<Streak?>(
        future: _streakFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Streak was not found.'));
          }

          final streak = snapshot.data!;
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
                          _InfoRow(label: 'Completed today', value: completions.isNotEmpty && completions.first.completedDate.year == DateTime.now().year && completions.first.completedDate.month == DateTime.now().month && completions.first.completedDate.day == DateTime.now().day ? 'Yes' : 'No'),
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
