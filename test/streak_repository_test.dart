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

  Future<int> createStreak({
    required Frequency frequency,
    List<int> scheduledDays = const [],
  }) {
    return repository.add(
      Streak(
        title: 'Test streak',
        frequency: frequency,
        scheduledDays: scheduledDays,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
  }

  test('awards the first freeze on the fifth consecutive daily completion',
      () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 4; day++) {
      await repository.markCompleted(streakId,
          completedDate: DateTime(2026, 1, day));
    }
    var streak = await repository.getById(streakId);
    expect(streak!.freezeCount, 0);
    expect(streak.completedSinceFreeze, 4);

    await repository.markCompleted(streakId,
        completedDate: DateTime(2026, 1, 5));
    streak = await repository.getById(streakId);
    expect(streak!.freezeCount, 1);
    expect(streak.completedSinceFreeze, 0);
  });

  test('custom weekdays count consecutive scheduled completions', () async {
    final streakId = await createStreak(
      frequency: Frequency.custom,
      scheduledDays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
    );

    for (final date in [
      DateTime(2026, 1, 5),
      DateTime(2026, 1, 7),
      DateTime(2026, 1, 9),
      DateTime(2026, 1, 12),
      DateTime(2026, 1, 14),
    ]) {
      await repository.markCompleted(streakId, completedDate: date);
    }

    final streak = await repository.getById(streakId);
    expect(streak!.currentStreak, 5);
    expect(streak.freezeCount, 1);
    expect(streak.completedSinceFreeze, 0);
  });

  test('missing a custom scheduled day breaks freeze progress', () async {
    final streakId = await createStreak(
      frequency: Frequency.custom,
      scheduledDays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
    );

    for (final date in [
      DateTime(2026, 1, 5),
      DateTime(2026, 1, 7),
      DateTime(2026, 1, 12),
      DateTime(2026, 1, 14),
      DateTime(2026, 1, 16),
    ]) {
      await repository.markCompleted(streakId, completedDate: date);
    }

    final streak = await repository.getById(streakId);
    expect(streak!.freezeCount, 0);
    expect(streak.completedSinceFreeze, 3);
  });

  test('weekly streak awards a freeze after five consecutive calendar weeks',
      () async {
    final streakId = await createStreak(frequency: Frequency.weekly);

    for (final date in [
      DateTime(2026, 1, 6),
      DateTime(2026, 1, 15),
      DateTime(2026, 1, 19),
      DateTime(2026, 1, 30),
      DateTime(2026, 2, 2),
    ]) {
      await repository.markCompleted(streakId, completedDate: date);
    }

    final streak = await repository.getById(streakId);
    final completions = await repository.getCompletionsForStreak(streakId);
    expect(completions, hasLength(5));
    expect(streak!.currentStreak, 5);
    expect(streak.freezeCount, 1);
  });

  test('weekly streak ignores a second completion in the same calendar week',
      () async {
    final streakId = await createStreak(frequency: Frequency.weekly);

    await repository.markCompleted(streakId,
        completedDate: DateTime(2026, 1, 5));
    await repository.markCompleted(streakId,
        completedDate: DateTime(2026, 1, 9));

    final streak = await repository.getById(streakId);
    final completions = await repository.getCompletionsForStreak(streakId);
    expect(completions, hasLength(1));
    expect(streak!.currentStreak, 1);
    expect(streak.completedSinceFreeze, 1);
  });

  test('earns one freeze per 5 successful days and caps at 3', () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 20; day++) {
      await repository.markCompleted(streakId,
          completedDate: DateTime(2026, 1, day));
    }

    final streak = await repository.getById(streakId);
    expect(streak, isNotNull);
    expect(streak!.freezeCount, 3);
    expect(streak.currentStreak, 20);
    expect(streak.longestStreak, 20);
    expect(streak.completedSinceFreeze <= 4, isTrue);
  });

  test('does not earn freeze from non-consecutive completion days', () async {
    final streakId = await createDailyStreak();

    for (var day in [1, 3, 5, 7, 9]) {
      await repository.markCompleted(streakId,
          completedDate: DateTime(2026, 1, day));
    }

    final streak = await repository.getById(streakId);
    expect(streak, isNotNull);
    expect(streak!.freezeCount, 0);
    expect(streak.completedSinceFreeze, 1);
  });

  test('uses freeze when a day is missed and streak continues', () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 5; day++) {
      await repository.markCompleted(streakId,
          completedDate: DateTime(2026, 2, day));
    }

    await repository.markCompleted(streakId,
        completedDate: DateTime(2026, 2, 7));

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

    await repository.markCompleted(streakId,
        completedDate: DateTime(2026, 3, 1));
    await repository.markCompleted(streakId,
        completedDate: DateTime(2026, 3, 3));

    final streak = await repository.getById(streakId);
    final completions = await repository.getCompletionsForStreak(streakId);

    expect(streak, isNotNull);
    expect(streak!.currentStreak, 1);
    expect(streak.longestStreak, 1);
    expect(streak.freezeCount, 0);
    expect(completions.first.usedFreeze, isFalse);
  });

  test('persists unlocked timestamp after achievement source metric changes',
      () async {
    final streakId = await createDailyStreak();

    final beforeDelete = await achievementRepository.getUnlockedAtMap();
    expect(beforeDelete[AchievementKeys.firstFlame], isNotNull);

    await repository.delete(streakId);

    final afterDelete = await achievementRepository.getUnlockedAtMap();
    expect(afterDelete[AchievementKeys.firstFlame],
        beforeDelete[AchievementKeys.firstFlame]);
  });

  test('stores unlocked timestamp when seven day sprint is reached', () async {
    final streakId = await createDailyStreak();

    for (var day = 1; day <= 7; day++) {
      await repository.markCompleted(streakId,
          completedDate: DateTime(2026, 4, day));
    }

    final unlockedAtMap = await achievementRepository.getUnlockedAtMap();
    expect(unlockedAtMap[AchievementKeys.sevenDaySprint], isNotNull);
  });

  test('builds a monthly completion summary for the calendar view', () async {
    final streakId = await createDailyStreak();

    for (var day in [1, 2, 4, 5, 7, 8, 9, 10, 14, 15, 16]) {
      await repository.markCompleted(streakId,
          completedDate: DateTime(2026, 3, day));
    }

    final summary = await repository.getMonthlyCompletionSummary(
        streakId, DateTime(2026, 3));

    expect(summary.month.year, 2026);
    expect(summary.month.month, 3);
    expect(summary.completedCount, 11);
    expect(summary.missedCount, 20);
    expect(summary.completionRate, closeTo(35.48, 0.1));
    expect(summary.completedDates.contains(DateTime(2026, 3, 1)), isTrue);
    expect(summary.missedDates.contains(DateTime(2026, 3, 3)), isTrue);
  });

  test('uses elapsed days for the current month completion rate', () async {
    final streakId = await createDailyStreak();
    final today = DateTime.now();

    await repository.markCompleted(
      streakId,
      completedDate: DateTime(today.year, today.month, 1),
    );

    final summary = await repository.getMonthlyCompletionSummary(
      streakId,
      today,
    );

    expect(summary.completionRate, closeTo(100 / today.day, 0.1));
  });
}
