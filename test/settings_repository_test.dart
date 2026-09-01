import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  var clearCalls = 0;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settingsRepository = SettingsRepository(db: db);
    clearCalls = 0;
  });

  tearDown(() => db.close());

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
