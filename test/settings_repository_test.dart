import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'package:streak_app/app/database/drift_database.dart';
import 'package:streak_app/core/enums/frequency.dart';
import 'package:streak_app/features/settings/data/models/app_settings.dart';
import 'package:streak_app/features/settings/data/repositories/settings_repository.dart';
import 'package:streak_app/features/settings/data/services/data_management_service.dart';
import 'package:streak_app/features/streaks/data/models/streak.dart';
import 'package:streak_app/features/streaks/data/repositories/streak_repository.dart';
import 'package:streak_app/features/todos/data/models/todo_item.dart';
import 'package:streak_app/features/todos/data/repositories/todo_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settingsRepository;
  var dbIsClosed = false;
  var clearCalls = 0;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settingsRepository = SettingsRepository(db: db);
    dbIsClosed = false;
    clearCalls = 0;
  });

  tearDown(() async {
    if (!dbIsClosed) {
      await db.close();
    }
  });

  test('new settings default to system theme with notifications off', () async {
    final settings = await settingsRepository.getSettings();

    expect(settings.themeMode, AppThemeMode.system);
    expect(settings.notificationsEnabled, isFalse);
    expect(settings.hapticsEnabled, isTrue);
  });

  test('updates settings without creating duplicate rows', () async {
    await settingsRepository.getSettings();
    await settingsRepository.updateThemeMode(AppThemeMode.dark);
    await settingsRepository.updateNotifications(true);
    await settingsRepository.updateHaptics(false);

    final rows = await db.select(db.appSettingsTable).get();
    final settings = await settingsRepository.getSettings();
    expect(rows, hasLength(1));
    expect(settings.themeMode, AppThemeMode.dark);
    expect(settings.notificationsEnabled, isTrue);
    expect(settings.hapticsEnabled, isFalse);
  });

  test('migrates legacy settings table before using conflict updates',
      () async {
    await db.close();
    dbIsClosed = true;
    final directory = await Directory.systemTemp.createTemp('streak_settings_');
    final databaseFile = File('${directory.path}/legacy.sqlite');
    final legacyDb = sqlite.sqlite3.open(databaseFile.path);
    legacyDb.execute('''
      CREATE TABLE app_settings_table (
        id INTEGER NOT NULL DEFAULT 1,
        dark_mode INTEGER NOT NULL DEFAULT 1 CHECK (dark_mode IN (0, 1)),
        notifications_enabled INTEGER NOT NULL DEFAULT 1
          CHECK (notifications_enabled IN (0, 1)),
        haptics_enabled INTEGER NOT NULL DEFAULT 1
          CHECK (haptics_enabled IN (0, 1)),
        theme_mode TEXT NOT NULL DEFAULT 'system'
      );
      INSERT INTO app_settings_table
        (id, dark_mode, notifications_enabled, haptics_enabled, theme_mode)
      VALUES (1, 1, 0, 1, 'dark');
      PRAGMA user_version = 6;
    ''');
    legacyDb.dispose();

    final migratedDb = AppDatabase.forTesting(NativeDatabase(databaseFile));
    final repository = SettingsRepository(db: migratedDb);
    try {
      final original = await repository.getSettings();
      expect(original.themeMode, AppThemeMode.dark);
      expect(original.notificationsEnabled, isFalse);
      expect(original.hapticsEnabled, isTrue);

      await migratedDb.into(migratedDb.appSettingsTable).insertOnConflictUpdate(
            AppSettingsTableCompanion.insert(
              id: const Value(1),
              darkMode: const Value(false),
              notificationsEnabled: const Value(true),
              hapticsEnabled: const Value(false),
              themeMode: const Value('light'),
            ),
          );

      final updated = await repository.getSettings();
      expect(updated.themeMode, AppThemeMode.light);
      expect(updated.notificationsEnabled, isTrue);
      expect(updated.hapticsEnabled, isFalse);
    } finally {
      await migratedDb.close();
      await directory.delete(recursive: true);
    }
  });

  test('export document is versioned and serializes local data', () async {
    await _seedActivity(db);
    await settingsRepository.saveSettings(
      AppSettings(themeMode: AppThemeMode.light, hapticsEnabled: false),
    );
    final service =
        DataManagementService(db: db, clearNotifications: () async {});

    final document = await service.buildExportDocument(
      packageInfo: PackageInfo(
        appName: 'Streak App',
        packageName: 'streak_app',
        version: '1.2.3',
        buildNumber: '4',
      ),
      exportedAt: DateTime.parse('2026-09-01T12:30:00+02:00'),
    );

    expect(document['formatVersion'], 1);
    expect(document['exportedAt'], '2026-09-01T10:30:00.000Z');
    expect((document['app'] as Map<String, dynamic>)['version'], '1.2.3');
    expect(
        (document['settings'] as Map<String, dynamic>)['themeMode'], 'light');
    expect(document['streaks'] as List, hasLength(1));
    expect(document['completions'] as List, hasLength(1));
    expect(document['todos'] as List, hasLength(1));
  });

  test('activity reset clears activity and preserves preferences', () async {
    await _seedActivity(db);
    await settingsRepository.saveSettings(
      AppSettings(
        themeMode: AppThemeMode.dark,
        notificationsEnabled: true,
        hapticsEnabled: false,
      ),
    );
    final service = DataManagementService(
      db: db,
      clearNotifications: () async => clearCalls++,
    );

    await service.resetActivity();

    expect(await db.select(db.streaksTable).get(), isEmpty);
    expect(await db.select(db.completionsTable).get(), isEmpty);
    expect(await db.select(db.todosTable).get(), isEmpty);
    expect(await db.select(db.achievementsTable).get(), isEmpty);
    final settings = await settingsRepository.getSettings();
    expect(settings.themeMode, AppThemeMode.dark);
    expect(settings.notificationsEnabled, isTrue);
    expect(settings.hapticsEnabled, isFalse);
    expect(clearCalls, 1);
  });

  test('factory reset clears activity and restores preference defaults',
      () async {
    await _seedActivity(db);
    await settingsRepository.saveSettings(
      AppSettings(
        themeMode: AppThemeMode.dark,
        notificationsEnabled: true,
        hapticsEnabled: false,
      ),
    );
    final service = DataManagementService(
      db: db,
      clearNotifications: () async => clearCalls++,
    );

    await service.factoryReset();

    expect(await db.select(db.streaksTable).get(), isEmpty);
    expect(await db.select(db.todosTable).get(), isEmpty);
    final settings = await settingsRepository.getSettings();
    expect(settings.themeMode, AppThemeMode.system);
    expect(settings.notificationsEnabled, isFalse);
    expect(settings.hapticsEnabled, isTrue);
    expect(clearCalls, 1);
  });
}

Future<void> _seedActivity(AppDatabase db) async {
  final streakId = await StreakRepository(db: db, syncNotifications: false).add(
    Streak(
      title: 'Read',
      frequency: Frequency.daily,
      createdAt: DateTime(2026, 1, 1),
    ),
  );
  await StreakRepository(db: db, syncNotifications: false).markCompleted(
    streakId,
    completedDate: DateTime(2026, 1, 1),
  );
  await TodoRepository(db: db, syncNotifications: false).add(
    TodoItem(title: 'Plan tomorrow', createdAt: DateTime(2026, 1, 1)),
  );
}
