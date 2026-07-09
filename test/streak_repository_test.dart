import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_app/app/database/drift_database.dart';
import 'package:streak_app/features/achievements/data/repositories/achievement_repository.dart';
import 'package:streak_app/features/achievements/domain/achievement_catalog.dart';
import 'package:streak_app/core/enums/frequency.dart';
import 'package:streak_app/features/streaks/data/models/streak.dart';
import 'package:streak_app/features/streaks/data/repositories/streak_repository.dart';

void main() {
  late AppDatabase db;
  late StreakRepository repository;
  late AchievementRepository achievementRepository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = StreakRepository(db: db, syncNotifications: false);
    achievementRepository = AchievementRepository(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> createDailyStreak() {
    return repository.add(
      Streak(
        title: 'Test streak',
        frequency: Frequency.daily,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
  }

  test('earns one freeze per 5 successful days and caps at 3', () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 20; day++) {
      await repository.markCompleted(streakId, completedDate: DateTime(2026, 1, day));
    }

    final streak = await repository.getById(streakId);
    expect(streak, isNotNull);
    expect(streak!.freezeCount, 3);
    expect(streak.currentStreak, 20);
    expect(streak.longestStreak, 20);
    expect(streak.completedSinceFreeze <= 4, isTrue);
  });

  test('uses freeze when a day is missed and streak continues', () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 5; day++) {
      await repository.markCompleted(streakId, completedDate: DateTime(2026, 2, day));
    }

    await repository.markCompleted(streakId, completedDate: DateTime(2026, 2, 7));

    final streak = await repository.getById(streakId);
    final completions = await repository.getCompletionsForStreak(streakId);

    expect(streak, isNotNull);
    expect(streak!.currentStreak, 6);
    expect(streak.freezeCount, 0);
    expect(streak.lastFreezeUsed, DateTime(2026, 2, 7));
    expect(completions.first.usedFreeze, isTrue);
  });

  test('resets streak when day is missed and no freeze exists', () async {
    final streakId = await createDailyStreak();

    await repository.markCompleted(streakId, completedDate: DateTime(2026, 3, 1));
    await repository.markCompleted(streakId, completedDate: DateTime(2026, 3, 3));

    final streak = await repository.getById(streakId);
    final completions = await repository.getCompletionsForStreak(streakId);

    expect(streak, isNotNull);
    expect(streak!.currentStreak, 1);
    expect(streak.longestStreak, 1);
    expect(streak.freezeCount, 0);
    expect(completions.first.usedFreeze, isFalse);
  });

  test('persists unlocked timestamp after achievement source metric changes', () async {
    final streakId = await createDailyStreak();

    final beforeDelete = await achievementRepository.getUnlockedAtMap();
    expect(beforeDelete[AchievementKeys.firstFlame], isNotNull);

    await repository.delete(streakId);

    final afterDelete = await achievementRepository.getUnlockedAtMap();
    expect(afterDelete[AchievementKeys.firstFlame], beforeDelete[AchievementKeys.firstFlame]);
  });

  test('stores unlocked timestamp when seven day sprint is reached', () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 7; day++) {
      await repository.markCompleted(streakId, completedDate: DateTime(2026, 4, day));
    }

    final unlockedAtMap = await achievementRepository.getUnlockedAtMap();
    expect(unlockedAtMap[AchievementKeys.sevenDaySprint], isNotNull);
  });
}
