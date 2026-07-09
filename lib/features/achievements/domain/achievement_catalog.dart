import 'package:flutter/material.dart';

import '../../streaks/data/models/streak.dart';

class AchievementKeys {
  static const firstFlame = 'first_flame';
  static const juggler = 'juggler';
  static const sevenDaySprint = 'seven_day_sprint';
  static const monthlyLegend = 'monthly_legend';
  static const iceLocker = 'ice_locker';
  static const closeCall = 'close_call';
  static const completionStarter = 'completion_starter';
  static const completionMaster = 'completion_master';
  static const reminderStarter = 'reminder_starter';
  static const reminderPlanner = 'reminder_planner';
  static const freezeHero = 'freeze_hero';
}

class AchievementDefinition {
  const AchievementDefinition({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.criteria,
    required this.currentValue,
    this.streakBadgeRule,
    this.shortLabel,
  });

  final String key;
  final String title;
  final String description;
  final IconData icon;
  final int target;
  final String criteria;
  final int Function(AchievementMetrics metrics) currentValue;
  final bool Function(Streak streak)? streakBadgeRule;
  final String? shortLabel;
}

class AchievementProgress {
  const AchievementProgress({
    required this.definition,
    required this.current,
    required this.unlockedAt,
  });

  final AchievementDefinition definition;
  final int current;
  final DateTime? unlockedAt;

  String get key => definition.key;
  String get title => definition.title;
  String get description => definition.description;
  IconData get icon => definition.icon;
  int get target => definition.target;
  String? get shortLabel => definition.shortLabel;

  bool get currentlyQualified => current >= target;
  bool get unlocked => unlockedAt != null || currentlyQualified;
  double get progress => target == 0 ? 0 : (current / target).clamp(0, 1).toDouble();
}

class AchievementBadge {
  const AchievementBadge({
    required this.key,
    required this.title,
    required this.icon,
    required this.shortLabel,
  });

  final String key;
  final String title;
  final IconData icon;
  final String shortLabel;
}

class AchievementMetrics {
  const AchievementMetrics({
    required this.streaks,
    required this.activeCount,
    required this.createdCount,
    required this.bestStreak,
    required this.totalFreezes,
    required this.usedFreezeCount,
    required this.totalCompletions,
    required this.freezeSaveCount,
    required this.reminderEnabledCount,
    required this.reminderSlotCount,
  });

  final List<Streak> streaks;
  final int activeCount;
  final int createdCount;
  final int bestStreak;
  final int totalFreezes;
  final int usedFreezeCount;
  final int totalCompletions;
  final int freezeSaveCount;
  final int reminderEnabledCount;
  final int reminderSlotCount;
}

final List<AchievementDefinition> achievementCatalog = [
  AchievementDefinition(
    key: AchievementKeys.firstFlame,
    title: 'First Flame',
    description: 'Create your first streak.',
    icon: Icons.whatshot,
    target: 1,
    criteria: 'Create at least 1 streak.',
    currentValue: (metrics) => metrics.createdCount,
  ),
  AchievementDefinition(
    key: AchievementKeys.juggler,
    title: 'Juggler',
    description: 'Keep 3 active streaks going at once.',
    icon: Icons.layers_outlined,
    target: 3,
    criteria: 'Have at least 3 active (not archived) streaks.',
    currentValue: (metrics) => metrics.activeCount,
  ),
  AchievementDefinition(
    key: AchievementKeys.sevenDaySprint,
    title: 'Seven Day Sprint',
    description: 'Reach a 7 day streak.',
    icon: Icons.bolt,
    target: 7,
    criteria: 'Reach a longest streak of at least 7 days.',
    currentValue: (metrics) => metrics.bestStreak,
    streakBadgeRule: _hasSevenDaySprint,
    shortLabel: '7d',
  ),
  AchievementDefinition(
    key: AchievementKeys.monthlyLegend,
    title: 'Monthly Legend',
    description: 'Reach a 30 day streak.',
    icon: Icons.calendar_month,
    target: 30,
    criteria: 'Reach a longest streak of at least 30 days.',
    currentValue: (metrics) => metrics.bestStreak,
    streakBadgeRule: _hasMonthlyLegend,
    shortLabel: '30d',
  ),
  AchievementDefinition(
    key: AchievementKeys.iceLocker,
    title: 'Ice Locker',
    description: 'Store 3 freezes at once.',
    icon: Icons.ac_unit,
    target: 3,
    criteria: 'Have at least 3 freezes available at the same time.',
    currentValue: (metrics) => metrics.totalFreezes,
    streakBadgeRule: _hasIceLocker,
    shortLabel: '3F',
  ),
  AchievementDefinition(
    key: AchievementKeys.closeCall,
    title: 'Close Call',
    description: 'Save a streak by using a freeze.',
    icon: Icons.shield_outlined,
    target: 1,
    criteria: 'Use a freeze at least once to save a streak.',
    currentValue: (metrics) => metrics.usedFreezeCount,
    streakBadgeRule: _hasCloseCall,
    shortLabel: 'Save',
  ),
  AchievementDefinition(
    key: AchievementKeys.completionStarter,
    title: 'Check-in Starter',
    description: 'Complete 25 total check-ins.',
    icon: Icons.task_alt,
    target: 25,
    criteria: 'Record at least 25 total streak completions.',
    currentValue: (metrics) => metrics.totalCompletions,
  ),
  AchievementDefinition(
    key: AchievementKeys.completionMaster,
    title: 'Century Check-ins',
    description: 'Complete 100 total check-ins.',
    icon: Icons.workspace_premium,
    target: 100,
    criteria: 'Record at least 100 total streak completions.',
    currentValue: (metrics) => metrics.totalCompletions,
  ),
  AchievementDefinition(
    key: AchievementKeys.reminderStarter,
    title: 'Reminder On',
    description: 'Enable reminders for a streak.',
    icon: Icons.notifications_active_outlined,
    target: 1,
    criteria: 'Have reminders enabled on at least 1 streak.',
    currentValue: (metrics) => metrics.reminderEnabledCount,
  ),
  AchievementDefinition(
    key: AchievementKeys.reminderPlanner,
    title: 'Time Architect',
    description: 'Configure 5 reminder times across streaks.',
    icon: Icons.schedule,
    target: 5,
    criteria: 'Set at least 5 reminder slots across all streaks.',
    currentValue: (metrics) => metrics.reminderSlotCount,
  ),
  AchievementDefinition(
    key: AchievementKeys.freezeHero,
    title: 'Freeze Hero',
    description: 'Save streaks with freeze 3 times.',
    icon: Icons.health_and_safety_outlined,
    target: 3,
    criteria: 'Use freeze saves in at least 3 completions.',
    currentValue: (metrics) => metrics.freezeSaveCount,
  ),
];

List<AchievementProgress> evaluateAchievements(
  AchievementMetrics metrics, {
  Map<String, DateTime> unlockedAtByKey = const {},
}) {
  return achievementCatalog
      .map(
        (definition) => AchievementProgress(
          definition: definition,
          current: definition.currentValue(metrics),
          unlockedAt: unlockedAtByKey[definition.key],
        ),
      )
      .toList();
}

AchievementMetrics buildAchievementMetrics(
  List<Streak> streaks, {
  int totalCompletions = 0,
  int freezeSaveCount = 0,
}) {
  final activeStreaks = streaks.where((streak) => !streak.archived).toList();
  final bestStreak = streaks.fold<int>(
    0,
    (best, streak) => streak.longestStreak > best ? streak.longestStreak : best,
  );
  final totalFreezes = streaks.fold<int>(0, (sum, streak) => sum + streak.freezeCount);
  final usedFreezeCount = streaks.where((streak) => streak.lastFreezeUsed != null).length;
  final reminderEnabledCount = streaks.where((streak) => streak.remindersEnabled).length;
  final reminderSlotCount = streaks.fold<int>(0, (sum, streak) => sum + streak.reminderTimes.length);

  return AchievementMetrics(
    streaks: streaks,
    activeCount: activeStreaks.length,
    createdCount: streaks.length,
    bestStreak: bestStreak,
    totalFreezes: totalFreezes,
    usedFreezeCount: usedFreezeCount,
    totalCompletions: totalCompletions,
    freezeSaveCount: freezeSaveCount,
    reminderEnabledCount: reminderEnabledCount,
    reminderSlotCount: reminderSlotCount,
  );
}

List<AchievementBadge> buildBadgesForStreak(Streak streak) {
  return achievementCatalog
      .where((definition) => definition.streakBadgeRule?.call(streak) ?? false)
      .map(
        (definition) => AchievementBadge(
          key: definition.key,
          title: definition.title,
          icon: definition.icon,
          shortLabel: definition.shortLabel ?? definition.title,
        ),
      )
      .toList();
}

bool _hasSevenDaySprint(Streak streak) => streak.longestStreak >= 7;

bool _hasMonthlyLegend(Streak streak) => streak.longestStreak >= 30;

bool _hasIceLocker(Streak streak) => streak.freezeCount >= 3;

bool _hasCloseCall(Streak streak) => streak.lastFreezeUsed != null;