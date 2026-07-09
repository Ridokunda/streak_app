import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/achievement_repository.dart';

final achievementRepositoryProvider = Provider((ref) => AchievementRepository());

final achievementTimelineProvider = StreamProvider<Map<String, DateTime>>((ref) {
  return ref.watch(achievementRepositoryProvider).watchUnlockedAtMap();
});

final completionStatsProvider = FutureProvider<CompletionStats>((ref) {
  return ref.watch(achievementRepositoryProvider).getCompletionStats();
});