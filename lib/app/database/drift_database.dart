import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

class StreaksTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get frequency => text()();
  TextColumn get scheduledDays => text().withDefault(const Constant('[]'))();
  IntColumn get reminderHour => integer().withDefault(const Constant(20))();
  IntColumn get reminderMinute => integer().withDefault(const Constant(0))();
  BoolColumn get remindersEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get reminderTimes => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastCompleted => dateTime().nullable()();
  DateTimeColumn get lastFreezeUsed => dateTime().nullable()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  IntColumn get freezeCount => integer().withDefault(const Constant(0))();
  IntColumn get completedSinceFreeze => integer().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class CompletionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get streakId => integer()();
  DateTimeColumn get completedDate => dateTime()();
  BoolColumn get usedFreeze => boolean().withDefault(const Constant(false))();
}

class AppSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get darkMode => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get hapticsEnabled => boolean().withDefault(const Constant(true))();
}

class AchievementsTable extends Table {
  TextColumn get key => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {key};
}

class TodosTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [
  StreaksTable,
  CompletionsTable,
  AppSettingsTable,
  AchievementsTable,
  TodosTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.executor);

  AppDatabase.forTesting(super.executor);

  static AppDatabase? _instance;

  static Future<AppDatabase> instance() async {
    _instance ??= AppDatabase._(_openConnection());
    return _instance!;
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(streaksTable, streaksTable.remindersEnabled);
            await migrator.addColumn(streaksTable, streaksTable.reminderTimes);
          }
          if (from < 3) {
            await migrator.createTable(achievementsTable);
          }
          if (from < 4) {
            await migrator.createTable(todosTable);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(p.join(directory.path, 'streak_app.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
