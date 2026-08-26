import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../app/database/drift_database.dart';
import '../../../../core/enums/frequency.dart';
import '../../../achievements/data/repositories/achievement_repository.dart';
import '../../../notifications/data/services/reminder_notification_service.dart';
import '../models/completion.dart';
import '../models/monthly_completion_summary.dart';
import '../models/streak.dart';

class StreakRepository {
  StreakRepository({AppDatabase? db, bool? syncNotifications})
      : _db = db,
        _syncNotifications = syncNotifications ?? db == null;

  final AppDatabase? _db;
  final bool _syncNotifications;

  Future<AppDatabase> get _dbInstance async =>
      _db ?? await AppDatabase.instance();

  Future<int> add(Streak streak) async {
    final db = await _dbInstance;
    final id =
        await db.into(db.streaksTable).insert(_streakToCompanion(streak));
    await _syncAchievements();

    if (_syncNotifications) {
      streak.id = id;
      await ReminderNotificationService.instance.syncStreakReminders(streak);
    }

    return id;
  }

  Future<List<Streak>> getAll() async {
    final db = await _dbInstance;
    final rows = await (db.select(db.streaksTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_streakFromRow).toList();
  }

  Stream<List<Streak>> watchAll() async* {
    final db = await _dbInstance;
    yield* db
        .select(db.streaksTable)
        .watch()
        .map((rows) => rows.map(_streakFromRow).toList());
  }

  Future<Streak?> getById(int id) async {
    final db = await _dbInstance;
    final row = await (db.select(db.streaksTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _streakFromRow(row);
  }

  Future<List<Completion>> getCompletionsForStreak(int streakId) async {
    final db = await _dbInstance;
    final rows = await (db.select(db.completionsTable)
          ..where((t) => t.streakId.equals(streakId))
          ..orderBy([(t) => OrderingTerm.desc(t.completedDate)]))
        .get();
    return rows.map(_completionFromRow).toList();
  }

  Future<MonthlyCompletionSummary> getMonthlyCompletionSummary(
    int streakId,
    DateTime month,
  ) async {
    final completions = await getCompletionsForStreak(streakId);
    final normalizedMonth = DateTime(month.year, month.month);
    final monthStart = DateTime(normalizedMonth.year, normalizedMonth.month, 1);
    final nextMonth = DateTime(
      normalizedMonth.month == 12
          ? normalizedMonth.year + 1
          : normalizedMonth.year,
      normalizedMonth.month == 12 ? 1 : normalizedMonth.month + 1,
      1,
    );

    final completedDates = completions
        .map((completion) => completion.completedDate)
        .where((date) => !date.isBefore(monthStart) && date.isBefore(nextMonth))
        .toList()
      ..sort();

    final totalDaysInMonth =
        DateTime(normalizedMonth.year, normalizedMonth.month + 1, 0).day;
    final monthDates = List.generate(
      totalDaysInMonth,
      (index) =>
          DateTime(normalizedMonth.year, normalizedMonth.month, index + 1),
    );

    final completedSet = completedDates
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet();
    final missedDates = monthDates
        .where((date) =>
            !completedSet.contains(DateTime(date.year, date.month, date.day)))
        .toList();

    final completedCount = completedDates.length;
    final missedCount = missedDates.length;
    final completionRate =
        totalDaysInMonth == 0 ? 0.0 : (completedCount / totalDaysInMonth) * 100;

    return MonthlyCompletionSummary(
      month: normalizedMonth,
      completedDates: completedDates,
      missedDates: missedDates,
      completedCount: completedCount,
      missedCount: missedCount,
      completionRate: completionRate.toDouble(),
    );
  }

  Future<void> refreshStreakCompletionFlags() async {
    final db = await _dbInstance;
    final rows = await db.select(db.streaksTable).get();
    final today = DateTime.now();

    for (final row in rows) {
      final shouldBeCompletedToday =
          row.lastCompleted != null && _isSameDay(row.lastCompleted!, today);
      if (row.completedToday != shouldBeCompletedToday) {
        await (db.update(db.streaksTable)..where((t) => t.id.equals(row.id)))
            .write(
          StreaksTableCompanion(
            completedToday: Value(shouldBeCompletedToday),
          ),
        );
      }
    }
  }

  Future<void> markCompleted(int streakId, {DateTime? completedDate}) async {
    final db = await _dbInstance;
    final date = completedDate ?? DateTime.now();

    await db.transaction(() async {
      final existingCompletions = await (db.select(db.completionsTable)
            ..where((t) => t.streakId.equals(streakId)))
          .get();
      final existing = existingCompletions.where((completion) {
        return completion.completedDate.year == date.year &&
            completion.completedDate.month == date.month &&
            completion.completedDate.day == date.day;
      }).toList();

      if (existing.isNotEmpty) {
        return;
      }

      final streakRow = await (db.select(db.streaksTable)
            ..where((t) => t.id.equals(streakId)))
          .getSingleOrNull();
      if (streakRow == null) {
        return;
      }

      final today = DateTime(date.year, date.month, date.day);
      final frequency = Frequency.values.firstWhere(
        (value) => value.name == streakRow.frequency,
        orElse: () => Frequency.daily,
      );
      final Set<int> scheduledDays = streakRow.scheduledDays.isEmpty
          ? <int>{}
          : (jsonDecode(streakRow.scheduledDays) as List)
              .map((value) => int.parse(value.toString()))
              .toSet();

      if (frequency == Frequency.custom &&
          !scheduledDays.contains(today.weekday)) {
        return;
      }

      var usedFreeze = false;
      var newFreezeCount = streakRow.freezeCount;
      var newCurrentStreak = streakRow.currentStreak;
      var lastFreezeUsed = streakRow.lastFreezeUsed;
      var completedSinceFreeze = 1;

      if (streakRow.lastCompleted != null) {
        final previousDay = DateTime(
          streakRow.lastCompleted!.year,
          streakRow.lastCompleted!.month,
          streakRow.lastCompleted!.day,
        );
        final gapDays = today.difference(previousDay).inDays;

        if (gapDays <= 0) {
          return;
        }

        final scheduleGap = _scheduleGap(
          previousDay,
          today,
          frequency: frequency,
          scheduledDays: scheduledDays,
        );

        // Weekly streaks can only be completed once in the same calendar week.
        if (scheduleGap < 0) {
          return;
        }

        if (scheduleGap == 0) {
          newCurrentStreak = streakRow.currentStreak + 1;
          completedSinceFreeze = streakRow.completedSinceFreeze + 1;
        } else {
          if (newFreezeCount >= scheduleGap) {
            usedFreeze = true;
            newFreezeCount -= scheduleGap;
            lastFreezeUsed = today;
            newCurrentStreak = streakRow.currentStreak + 1;
          } else {
            newCurrentStreak = 1;
          }

          // A missed scheduled occurrence breaks consecutive completions, even if
          // a freeze saves the streak.
          completedSinceFreeze = 1;
        }
      } else {
        newCurrentStreak = 1;
        completedSinceFreeze = 1;
      }

      await db.into(db.completionsTable).insert(
            CompletionsTableCompanion.insert(
              streakId: streakId,
              completedDate: date,
              usedFreeze: Value(usedFreeze),
            ),
          );

      while (completedSinceFreeze >= 5 && newFreezeCount < 3) {
        completedSinceFreeze -= 5;
        newFreezeCount += 1;
      }

      if (newFreezeCount >= 3 && completedSinceFreeze > 4) {
        completedSinceFreeze = 4;
      }

      await (db.update(db.streaksTable)..where((t) => t.id.equals(streakId)))
          .write(
        StreaksTableCompanion(
          currentStreak: Value(newCurrentStreak),
          longestStreak: Value(max(streakRow.longestStreak, newCurrentStreak)),
          lastCompleted: Value(today),
          completedToday: const Value(true),
          freezeCount: Value(newFreezeCount),
          lastFreezeUsed: Value(lastFreezeUsed),
          completedSinceFreeze: Value(completedSinceFreeze),
        ),
      );
    });

    if (_syncNotifications) {
      final streak = await getById(streakId);
      if (streak != null) {
        await ReminderNotificationService.instance.syncStreakReminders(streak);
      }
    }

    await _syncAchievements();
  }

  Future<void> delete(int id) async {
    final db = await _dbInstance;

    if (_syncNotifications) {
      await ReminderNotificationService.instance.cancelStreakReminders(id);
    }

    await db.transaction(() async {
      await (db.delete(db.completionsTable)
            ..where((t) => t.streakId.equals(id)))
          .go();
      await (db.delete(db.streaksTable)..where((t) => t.id.equals(id))).go();
    });

    await _syncAchievements();
  }

  Future<void> update(Streak streak) async {
    final db = await _dbInstance;
    if (streak.id == null) {
      return;
    }

    await db.update(db.streaksTable).replace(_streakToData(streak));
    await _syncAchievements();

    if (_syncNotifications) {
      await ReminderNotificationService.instance.syncStreakReminders(streak);
    }
  }

  Future<void> _syncAchievements() async {
    final db = await _dbInstance;
    final streaks = await getAll();
    await AchievementRepository(db: db).syncFromStreaks(streaks);
  }

  StreaksTableCompanion _streakToCompanion(Streak streak) {
    final firstReminderMinute =
        streak.reminderTimes.isEmpty ? 20 * 60 : streak.reminderTimes.first;

    return StreaksTableCompanion(
      title: Value(streak.title),
      description: Value(streak.description),
      frequency: Value(streak.frequency.name),
      scheduledDays: Value(jsonEncode(streak.scheduledDays)),
      reminderHour: Value(firstReminderMinute ~/ 60),
      reminderMinute: Value(firstReminderMinute % 60),
      remindersEnabled: Value(streak.remindersEnabled),
      reminderTimes: Value(jsonEncode(streak.reminderTimes)),
      createdAt: Value(streak.createdAt),
      lastCompleted: Value(streak.lastCompleted),
      completedToday: Value(streak.completedToday),
      lastFreezeUsed: Value(streak.lastFreezeUsed),
      currentStreak: Value(streak.currentStreak),
      longestStreak: Value(streak.longestStreak),
      freezeCount: Value(streak.freezeCount),
      completedSinceFreeze: Value(streak.completedSinceFreeze),
      archived: Value(streak.archived),
    );
  }

  StreaksTableData _streakToData(Streak streak) {
    final firstReminderMinute =
        streak.reminderTimes.isEmpty ? 20 * 60 : streak.reminderTimes.first;

    return StreaksTableData(
      id: streak.id ?? 0,
      title: streak.title,
      description: streak.description,
      frequency: streak.frequency.name,
      scheduledDays: jsonEncode(streak.scheduledDays),
      reminderHour: firstReminderMinute ~/ 60,
      reminderMinute: firstReminderMinute % 60,
      remindersEnabled: streak.remindersEnabled,
      reminderTimes: jsonEncode(streak.reminderTimes),
      createdAt: streak.createdAt,
      lastCompleted: streak.lastCompleted,
      completedToday: streak.completedToday,
      lastFreezeUsed: streak.lastFreezeUsed,
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      freezeCount: streak.freezeCount,
      completedSinceFreeze: streak.completedSinceFreeze,
      archived: streak.archived,
    );
  }

  Streak _streakFromRow(StreaksTableData row) {
    final decodedReminderTimes = row.reminderTimes.isEmpty
        ? <int>[]
        : (jsonDecode(row.reminderTimes) as List)
            .map((value) => int.parse(value.toString()))
            .toList();

    final reminderTimes = decodedReminderTimes.isNotEmpty
        ? decodedReminderTimes
        : (row.remindersEnabled
            ? <int>[row.reminderHour * 60 + row.reminderMinute]
            : <int>[]);

    return Streak(
      id: row.id,
      title: row.title,
      description: row.description,
      frequency: Frequency.values.firstWhere(
        (value) => value.name == row.frequency,
        orElse: () => Frequency.daily,
      ),
      scheduledDays: row.scheduledDays.isEmpty
          ? const []
          : (jsonDecode(row.scheduledDays) as List)
              .map((value) => int.parse(value.toString()))
              .toList(),
      remindersEnabled: row.remindersEnabled,
      reminderTimes: reminderTimes,
      createdAt: row.createdAt,
      lastCompleted: row.lastCompleted,
      completedToday: row.completedToday,
      lastFreezeUsed: row.lastFreezeUsed,
      currentStreak: row.currentStreak,
      longestStreak: row.longestStreak,
      freezeCount: row.freezeCount,
      completedSinceFreeze: row.completedSinceFreeze,
      archived: row.archived,
    );
  }

  Completion _completionFromRow(CompletionsTableData row) {
    return Completion(
      id: row.id,
      streakId: row.streakId,
      completedDate: row.completedDate,
      usedFreeze: row.usedFreeze,
    );
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  int _scheduleGap(
    DateTime previous,
    DateTime current, {
    required Frequency frequency,
    required Set<int> scheduledDays,
  }) {
    switch (frequency) {
      case Frequency.daily:
        return current.difference(previous).inDays - 1;
      case Frequency.weekly:
        final previousWeek = _startOfWeek(previous);
        final currentWeek = _startOfWeek(current);
        final weeksApart = currentWeek.difference(previousWeek).inDays ~/ 7;
        return weeksApart - 1;
      case Frequency.custom:
        var missedScheduledDays = 0;
        var cursor = previous.add(const Duration(days: 1));
        while (cursor.isBefore(current)) {
          if (scheduledDays.contains(cursor.weekday)) {
            missedScheduledDays += 1;
          }
          cursor = cursor.add(const Duration(days: 1));
        }
        return missedScheduledDays;
    }
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized
        .subtract(Duration(days: normalized.weekday - DateTime.monday));
  }
}
