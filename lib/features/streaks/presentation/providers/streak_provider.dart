import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/streak.dart';
import '../../data/repositories/streak_repository.dart';

final streakRepositoryProvider =
    Provider((ref) => StreakRepository());

final streakListProvider =
    StreamProvider<List<Streak>>((ref) {
  return ref.watch(streakRepositoryProvider).watchAll();
});