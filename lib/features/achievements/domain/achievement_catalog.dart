import 'package:flutter/material.dart';

import '../../streaks/data/models/streak.dart';

class AchievementKeys {
  static const firstFlame = 'first_flame';
  static const juggler = 'juggler';
  static const sevenDaySprint = 'seven_day_sprint';
  static const monthlyLegend = 'monthly_legend';
  static const iceLocker = 'ice_locker';
  static const closeCall = 'close_call';
}

class AchievementDefinition {
  const AchievementDefinition({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.currentValue,
    this.streakBadgeRule,
    this.shortLabel,
  });

  final String key;
  final String title;
  final String description;
  final IconData icon;
  final int target;
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
  });

  final List<Streak> streaks;
  final int activeCount;
  final int createdCount;
  final int bestStreak;
  final int totalFreezes;
  final int usedFreezeCount;
}

final List<AchievementDefinition> achievementCatalog = [
  AchievementDefinition(
    key: AchievementKeys.firstFlame,
    title: 'First Flame',
    description: 'Create your first streak.',
    icon: Icons.whatshot,
    target: 1,
    currentValue: (metrics) => metrics.createdCount,
  ),
  AchievementDefinition(
    key: AchievementKeys.juggler,
    title: 'Juggler',
    description: 'Keep 3 active streaks going at once.',
    icon: Icons.layers_outlined,
    target: 3,
    currentValue: (metrics) => metrics.activeCount,
  ),
  AchievementDefinition(
    key: AchievementKeys.sevenDaySprint,
    title: 'Seven Day Sprint',
    description: 'Reach a 7 day streak.',
    icon: Icons.bolt,
    target: 7,
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
    currentValue: (metrics) => metrics.usedFreezeCount,
    streakBadgeRule: _hasCloseCall,
    shortLabel: 'Save',
  ),
];

List<AchievementProgress> evaluateAchievements(
  List<Streak> streaks, {
  Map<String, DateTime> unlockedAtByKey = const {},
}) {
  final metrics = buildAchievementMetrics(streaks);

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

AchievementMetrics buildAchievementMetrics(List<Streak> streaks) {
  final activeStreaks = streaks.where((streak) => !streak.archived).toList();
  final bestStreak = streaks.fold<int>(
    0,
    (best, streak) => streak.longestStreak > best ? streak.longestStreak : best,
  );
  final totalFreezes = streaks.fold<int>(0, (sum, streak) => sum + streak.freezeCount);
  final usedFreezeCount = streaks.where((streak) => streak.lastFreezeUsed != null).length;

  return AchievementMetrics(
    streaks: streaks,
    activeCount: activeStreaks.length,
    createdCount: streaks.length,
    bestStreak: bestStreak,
    totalFreezes: totalFreezes,
    usedFreezeCount: usedFreezeCount,
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