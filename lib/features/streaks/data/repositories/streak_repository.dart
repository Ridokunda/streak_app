import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../app/database/drift_database.dart';
import '../../../../core/enums/frequency.dart';
import '../../../achievements/data/repositories/achievement_repository.dart';
import '../../../notifications/data/services/reminder_notification_service.dart';
import '../models/completion.dart';
import '../models/streak.dart';

class StreakRepository {
  StreakRepository({AppDatabase? db, bool? syncNotifications})
      : _db = db,
        _syncNotifications = syncNotifications ?? db == null;

  final AppDatabase? _db;
  final bool _syncNotifications;

  Future<AppDatabase> get _dbInstance async => _db ?? await AppDatabase.instance();

  Future<int> add(Streak streak) async {
    final db = await _dbInstance;
    final id = await db.into(db.streaksTable).insert(_streakToCompanion(streak));
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
    yield* db.select(db.streaksTable).watch().map((rows) => rows.map(_streakFromRow).toList());
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

        if (gapDays == 1) {
          newCurrentStreak = streakRow.currentStreak + 1;
          completedSinceFreeze = streakRow.completedSinceFreeze + 1;
        } else {
          final missedDays = gapDays - 1;
          if (newFreezeCount >= missedDays) {
            usedFreeze = true;
            newFreezeCount -= missedDays;
            lastFreezeUsed = today;
            newCurrentStreak = streakRow.currentStreak + 1;
          } else {
            newCurrentStreak = 1;
          }

          // A missed day breaks consecutive completions, even if a freeze saves the streak.
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

      await (db.update(db.streaksTable)
            ..where((t) => t.id.equals(streakId)))
          .write(
        StreaksTableCompanion(
          currentStreak: Value(newCurrentStreak),
          longestStreak: Value(max(streakRow.longestStreak, newCurrentStreak)),
          lastCompleted: Value(today),
          freezeCount: Value(newFreezeCount),
          lastFreezeUsed: Value(lastFreezeUsed),
          completedSinceFreeze: Value(completedSinceFreeze),
        ),
      );
    });

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
      await (db.delete(db.streaksTable)
            ..where((t) => t.id.equals(id)))
          .go();
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
      : (row.remindersEnabled ? <int>[row.reminderHour * 60 + row.reminderMinute] : <int>[]);

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
}
