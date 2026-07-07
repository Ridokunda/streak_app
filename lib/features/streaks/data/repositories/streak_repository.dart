import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../app/database/drift_database.dart';
import '../../../../core/enums/frequency.dart';
import '../models/completion.dart';
import '../models/streak.dart';

class StreakRepository {
  StreakRepository({AppDatabase? db}) : _db = db;

  final AppDatabase? _db;

  Future<AppDatabase> get _dbInstance async => _db ?? await AppDatabase.instance();

  Future<int> add(Streak streak) async {
    final db = await _dbInstance;
    return db.into(db.streaksTable).insert(_streakToCompanion(streak));
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

      await db.into(db.completionsTable).insert(
        CompletionsTableCompanion.insert(
          streakId: streakId,
          completedDate: date,
          usedFreeze: const Value(false),
        ),
      );

      final today = DateTime(date.year, date.month, date.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final previousCompletion = existingCompletions.where((completion) {
        return completion.completedDate.year == yesterday.year &&
            completion.completedDate.month == yesterday.month &&
            completion.completedDate.day == yesterday.day;
      }).toList();

      final newCurrentStreak = previousCompletion.isEmpty ? 1 : streakRow.currentStreak + 1;
      await (db.update(db.streaksTable)
            ..where((t) => t.id.equals(streakId)))
          .write(
        StreaksTableCompanion(
          currentStreak: Value(newCurrentStreak),
          longestStreak: Value(max(streakRow.longestStreak, newCurrentStreak)),
          lastCompleted: Value(today),
          completedSinceFreeze: Value(streakRow.completedSinceFreeze + 1),
        ),
      );
    });
  }

  Future<void> delete(int id) async {
    final db = await _dbInstance;

    await db.transaction(() async {
      await (db.delete(db.completionsTable)
            ..where((t) => t.streakId.equals(id)))
          .go();
      await (db.delete(db.streaksTable)
            ..where((t) => t.id.equals(id)))
          .go();
    });
  }

  Future<void> update(Streak streak) async {
    final db = await _dbInstance;
    if (streak.id == null) {
      return;
    }

    await db.update(db.streaksTable).replace(_streakToData(streak));
  }

  StreaksTableCompanion _streakToCompanion(Streak streak) {
    return StreaksTableCompanion(
      title: Value(streak.title),
      description: Value(streak.description),
      frequency: Value(streak.frequency.name),
      scheduledDays: Value(jsonEncode(streak.scheduledDays)),
      reminderHour: Value(streak.reminderHour),
      reminderMinute: Value(streak.reminderMinute),
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
    return StreaksTableData(
      id: streak.id ?? 0,
      title: streak.title,
      description: streak.description,
      frequency: streak.frequency.name,
      scheduledDays: jsonEncode(streak.scheduledDays),
      reminderHour: streak.reminderHour,
      reminderMinute: streak.reminderMinute,
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
      reminderHour: row.reminderHour,
      reminderMinute: row.reminderMinute,
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
