import 'package:isar/isar.dart';

import '../../../../app/database/isar_database.dart';
import '../models/streak.dart';

class StreakRepository {
  Future<Isar> get _db async => await IsarDatabase.instance();

  Future<void> add(Streak streak) async {
    final db = await _db;

    await db.writeTxn(() async {
      await db.streaks.put(streak);
    });
  }

  Future<List<Streak>> getAll() async {
    final db = await _db;

    return db.streaks.where().findAll();
  }

  Stream<List<Streak>> watchAll() async* {
    final db = await _db;

    yield* db.streaks.where().watch(fireImmediately: true);
  }

  Future<void> delete(int id) async {
    final db = await _db;

    await db.writeTxn(() async {
      await db.streaks.delete(id);
    });
  }

  Future<void> update(Streak streak) async {
    final db = await _db;

    await db.writeTxn(() async {
      await db.streaks.put(streak);
    });
  }
}