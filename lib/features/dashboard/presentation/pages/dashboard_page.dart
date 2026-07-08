import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/frequency.dart';
import '../../../streaks/data/models/streak.dart';
import '../../../streaks/presentation/providers/streak_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streaksAsync = ref.watch(streakListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.push('/create-streak'),
            icon: const Icon(Icons.add),
            tooltip: 'Create Streak',
          ),
        ],
      ),
      body: streaksAsync.when(
        data: (streaks) {
          final activeStreaks = streaks.where((streak) => !streak.archived).toList();
          final totalActive = activeStreaks.length;
          final bestStreak = activeStreaks.fold<int>(0, (max, streak) => streak.currentStreak > max ? streak.currentStreak : max);
          final longest = activeStreaks.fold<int>(0, (max, streak) => streak.longestStreak > max ? streak.longestStreak : max);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Keep your streaks alive and review your progress at a glance.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.push('/create-streak'),
                icon: const Icon(Icons.add),
                label: const Text('Create Streak'),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _SummaryCard(
                    title: 'Active streaks',
                    value: '$totalActive',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                  _SummaryCard(
                    title: 'Current best',
                    value: '$bestStreak day${bestStreak == 1 ? '' : 's'}',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                  _SummaryCard(
                    title: 'Longest streak',
                    value: '$longest day${longest == 1 ? '' : 's'}',
                    icon: Icons.emoji_events,
                    color: Colors.purple,
                  ),
                  _SummaryCard(
                    title: 'Ready to track',
                    value: totalActive == 0 ? 'None' : 'Today',
                    icon: Icons.check_circle_outline,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Your streaks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => context.push('/create-streak'),
                    icon: const Icon(Icons.add),
                    label: const Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (activeStreaks.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.bubble_chart, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'No active streaks yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first streak to start building momentum.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...activeStreaks.map((streak) => _StreakTile(streak: streak)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load streaks: $error')),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({required this.streak});

  final Streak streak;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/streaks/${streak.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  streak.frequency == Frequency.daily ? Icons.calendar_today : Icons.event,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streak.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${streak.currentStreak} day streak • ${streak.frequency.name.capitalize()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (streak.description != null && streak.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        streak.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
