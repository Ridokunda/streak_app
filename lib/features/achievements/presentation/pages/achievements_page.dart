import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/achievement_catalog.dart';
import '../providers/achievement_provider.dart';
import '../../../streaks/data/models/streak.dart';
import '../../../streaks/presentation/providers/streak_provider.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streaksAsync = ref.watch(streakListProvider);
    final timelineAsync = ref.watch(achievementTimelineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: streaksAsync.when(
        data: (streaks) => timelineAsync.when(
          data: (unlockedAtByKey) {
            final achievements = evaluateAchievements(streaks, unlockedAtByKey: unlockedAtByKey);
            final unlocked = achievements.where((achievement) => achievement.unlocked).toList();
            final inProgress = achievements.where((achievement) => !achievement.unlocked).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Milestones',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Track streak consistency, momentum, and freeze mastery.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Unlocked',
                        value: '${unlocked.length}/${achievements.length}',
                        icon: Icons.emoji_events,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Best streak',
                        value: '${_bestStreak(streaks)} days',
                        icon: Icons.local_fire_department,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (streaks.isEmpty)
                  const _EmptyAchievementsState()
                else ...[
                  Text(
                    'Unlocked achievements',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (unlocked.isEmpty)
                    const Text('No achievements unlocked yet.')
                  else
                    ...unlocked.map((achievement) => _AchievementTile(achievement: achievement)),
                  const SizedBox(height: 24),
                  Text(
                    'In progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...inProgress.map((achievement) => _AchievementTile(achievement: achievement)),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Unable to load achievements: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load achievements: $error')),
      ),
    );
  }

  int _bestStreak(List<Streak> streaks) {
    return streaks.fold<int>(0, (max, streak) => streak.longestStreak > max ? streak.longestStreak : max);
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});

  final AchievementProgress achievement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = achievement.unlocked ? Colors.amber : colorScheme.primary;
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: accentColor.withValues(alpha: 0.16),
                  child: Icon(achievement.icon, color: accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(achievement.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(achievement.description, style: Theme.of(context).textTheme.bodyMedium),
                      if (achievement.unlockedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Earned ${dateFormatter.format(achievement.unlockedAt!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  achievement.unlocked ? 'Unlocked' : '${achievement.current}/${achievement.target}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: achievement.progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAchievementsState extends StatelessWidget {
  const _EmptyAchievementsState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.emoji_events_outlined, size: 40),
            const SizedBox(height: 12),
            Text('No achievements yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Create streaks and keep them alive to unlock milestones.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}