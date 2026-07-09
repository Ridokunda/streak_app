import '../../../../app/database/drift_database.dart';
import '../../../streaks/data/models/streak.dart';
import '../../domain/achievement_catalog.dart';

class AchievementRecord {
  const AchievementRecord({
    required this.key,
    required this.unlockedAt,
  });

  final String key;
  final DateTime unlockedAt;
}

class AchievementRepository {
  AchievementRepository({AppDatabase? db}) : _db = db;

  final AppDatabase? _db;

  Future<AppDatabase> get _dbInstance async => _db ?? await AppDatabase.instance();

  Stream<Map<String, DateTime>> watchUnlockedAtMap() async* {
    final db = await _dbInstance;
    yield* db.select(db.achievementsTable).watch().map(
          (rows) => {
            for (final row in rows) row.key: row.unlockedAt,
          },
        );
  }

  Future<Map<String, DateTime>> getUnlockedAtMap() async {
    final db = await _dbInstance;
    final rows = await db.select(db.achievementsTable).get();
    return {
      for (final row in rows) row.key: row.unlockedAt,
    };
  }

  Future<void> syncFromStreaks(List<Streak> streaks) async {
    final db = await _dbInstance;
    final unlockedAtByKey = await getUnlockedAtMap();
    final progressList = evaluateAchievements(streaks, unlockedAtByKey: unlockedAtByKey);
    final now = DateTime.now();

    await db.transaction(() async {
      for (final progress in progressList) {
        if (!progress.currentlyQualified || unlockedAtByKey.containsKey(progress.key)) {
          continue;
        }

        await db.into(db.achievementsTable).insertOnConflictUpdate(
              AchievementsTableCompanion.insert(
                key: progress.key,
                unlockedAt: now,
              ),
            );
      }
    });
  }
}