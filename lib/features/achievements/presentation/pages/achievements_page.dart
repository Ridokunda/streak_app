import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/achievement_catalog.dart';
import '../providers/achievement_provider.dart';
import '../../../streaks/data/models/streak.dart';
import '../../../streaks/presentation/providers/streak_provider.dart';

class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({super.key});

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage> {
  final Set<String> _knownUnlockedKeys = <String>{};

  @override
  Widget build(BuildContext context) {
    final streaksAsync = ref.watch(streakListProvider);
    final timelineAsync = ref.watch(achievementTimelineProvider);
    final statsAsync = ref.watch(completionStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: streaksAsync.when(
        data: (streaks) => timelineAsync.when(
          data: (unlockedAtByKey) => statsAsync.when(
            data: (stats) {
              final metrics = buildAchievementMetrics(
                streaks,
                totalCompletions: stats.totalCompletions,
                freezeSaveCount: stats.freezeSaveCount,
              );
              final achievements = evaluateAchievements(metrics, unlockedAtByKey: unlockedAtByKey);
              final unlocked = achievements.where((achievement) => achievement.unlocked).toList();
              final inProgress = achievements.where((achievement) => !achievement.unlocked).toList();

              final newlyUnlocked = unlocked
                  .where((achievement) => !_knownUnlockedKeys.contains(achievement.key))
                  .toList();

              if (newlyUnlocked.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  _knownUnlockedKeys.addAll(newlyUnlocked.map((achievement) => achievement.key));
                  _showNewlyUnlockedBanner(context, newlyUnlocked.first);
                });
              } else {
                _knownUnlockedKeys.addAll(unlocked.map((achievement) => achievement.key));
              }

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
                      ...unlocked.map(
                        (achievement) => _AchievementTile(
                          achievement: achievement,
                          onTap: () => _showAchievementDetails(context, achievement),
                          animateEntry: newlyUnlocked.any((item) => item.key == achievement.key),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      'In progress',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...inProgress.map(
                      (achievement) => _AchievementTile(
                        achievement: achievement,
                        onTap: () => _showAchievementDetails(context, achievement),
                      ),
                    ),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load achievements: $error')),
      ),
    );
  }

  int _bestStreak(List<Streak> streaks) {
    return streaks.fold<int>(0, (max, streak) => streak.longestStreak > max ? streak.longestStreak : max);
  }

  void _showNewlyUnlockedBanner(BuildContext context, AchievementProgress achievement) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearMaterialBanners()
       ..showMaterialBanner(
         MaterialBanner(
           content: Row(
             children: [
               const Icon(Icons.emoji_events, color: Colors.amber),
               const SizedBox(width: 12),
               Expanded(
                 child: Text('New achievement unlocked: ${achievement.title}'),
               ),
             ],
           ),
           actions: [
             TextButton(
               onPressed: () {
                 messenger.hideCurrentMaterialBanner();
                 _showAchievementDetails(context, achievement);
               },
               child: const Text('View'),
             ),
             TextButton(
               onPressed: messenger.hideCurrentMaterialBanner,
               child: const Text('Dismiss'),
             ),
           ],
        ),
       );
  }

  Future<void> _showAchievementDetails(
    BuildContext context,
    AchievementProgress achievement,
  ) async {
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(achievement.icon),
              const SizedBox(width: 8),
              Expanded(child: Text(achievement.title)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(achievement.description),
              const SizedBox(height: 12),
              Text(
                'Unlock criteria',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(achievement.definition.criteria),
              const SizedBox(height: 12),
              Text(
                'Progress: ${achievement.current}/${achievement.target}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (achievement.unlockedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Earned history',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text('Unlocked on ${dateFormatter.format(achievement.unlockedAt!)}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
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
  const _AchievementTile({
    required this.achievement,
    required this.onTap,
    this.animateEntry = false,
  });

  final AchievementProgress achievement;
  final VoidCallback onTap;
  final bool animateEntry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = achievement.unlocked ? Colors.amber : colorScheme.primary;
    final dateFormatter = DateFormat('dd MMM yyyy');

    final tile = Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
      ),
    );

    if (!animateEntry) {
      return tile;
    }

    return tile
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.08, end: 0, duration: 250.ms);
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
