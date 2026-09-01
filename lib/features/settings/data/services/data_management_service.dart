import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/database/drift_database.dart';
import '../../../notifications/data/services/reminder_notification_service.dart';
import '../models/app_settings.dart';

class DataManagementService {
  DataManagementService({
    AppDatabase? db,
    Future<void> Function()? clearNotifications,
  })  : _db = db,
        _clearNotifications = clearNotifications ??
            ReminderNotificationService.instance.clearAllNotifications;

  final AppDatabase? _db;
  final Future<void> Function() _clearNotifications;

  Future<AppDatabase> get _database async =>
      _db ?? await AppDatabase.instance();

  Future<Map<String, dynamic>> buildExportDocument({
    required PackageInfo packageInfo,
    DateTime? exportedAt,
  }) async {
    final db = await _database;
    final now = (exportedAt ?? DateTime.now()).toUtc();
    final settingsRows = await (db.select(db.appSettingsTable)
          ..where((table) => table.id.equals(1)))
        .get();
    final settings = settingsRows.isEmpty ? null : settingsRows.first;
    final streaks = await db.select(db.streaksTable).get();
    final completions = await db.select(db.completionsTable).get();
    final todos = await db.select(db.todosTable).get();
    final achievements = await db.select(db.achievementsTable).get();

    String? date(DateTime? value) => value?.toUtc().toIso8601String();
    dynamic decodedList(String value) {
      if (value.isEmpty) return <dynamic>[];
      try {
        return jsonDecode(value);
      } catch (_) {
        return <dynamic>[];
      }
    }

    final document = <String, dynamic>{
      'formatVersion': 1,
      'exportedAt': now.toIso8601String(),
      'app': {
        'name': packageInfo.appName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      },
      'settings': {
        'themeMode': settings?.themeMode ?? AppThemeMode.system.name,
        'notificationsEnabled': settings?.notificationsEnabled ?? false,
        'hapticsEnabled': settings?.hapticsEnabled ?? true,
      },
      'streaks': [
        for (final row in streaks)
          {
            'id': row.id,
            'title': row.title,
            'description': row.description,
            'frequency': row.frequency,
            'scheduledDays': decodedList(row.scheduledDays),
            'remindersEnabled': row.remindersEnabled,
            'reminderTimes': decodedList(row.reminderTimes),
            'createdAt': date(row.createdAt),
            'lastCompleted': date(row.lastCompleted),
            'completedToday': row.completedToday,
            'lastFreezeUsed': date(row.lastFreezeUsed),
            'currentStreak': row.currentStreak,
            'longestStreak': row.longestStreak,
            'freezeCount': row.freezeCount,
            'completedSinceFreeze': row.completedSinceFreeze,
            'archived': row.archived,
          },
      ],
      'completions': [
        for (final row in completions)
          {
            'id': row.id,
            'streakId': row.streakId,
            'completedDate': date(row.completedDate),
            'usedFreeze': row.usedFreeze,
          },
      ],
      'todos': [
        for (final row in todos)
          {
            'id': row.id,
            'title': row.title,
            'isCompleted': row.isCompleted,
            'reminderEnabled': row.reminderEnabled,
            'reminderAt': date(row.reminderAt),
            'createdAt': date(row.createdAt),
          },
      ],
      'achievements': [
        for (final row in achievements)
          {'key': row.key, 'unlockedAt': date(row.unlockedAt)},
      ],
    };

    return document;
  }

  Future<void> exportData() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final now = DateTime.now().toUtc();
    final document = await buildExportDocument(
      packageInfo: packageInfo,
      exportedAt: now,
    );
    final directory = await getTemporaryDirectory();
    final stamp = now.toIso8601String().split('T').first;
    final file = File(p.join(directory.path, 'streak-app-export-$stamp.json'));
    await file
        .writeAsString(const JsonEncoder.withIndent('  ').convert(document));
    await SharePlus.instance.share(
      ShareParams(
        subject: 'Streak App data export',
        text: 'Your Streak App data export.',
        files: [XFile(file.path, mimeType: 'application/json')],
      ),
    );
  }

  Future<void> resetActivity() async {
    final db = await _database;
    await _clearNotifications();
    await db.transaction(() async {
      await db.delete(db.completionsTable).go();
      await db.delete(db.streaksTable).go();
      await db.delete(db.todosTable).go();
      await db.delete(db.achievementsTable).go();
    });
  }

  Future<void> factoryReset() async {
    final db = await _database;
    await _clearNotifications();
    await db.transaction(() async {
      await db.delete(db.completionsTable).go();
      await db.delete(db.streaksTable).go();
      await db.delete(db.todosTable).go();
      await db.delete(db.achievementsTable).go();
      await db.delete(db.appSettingsTable).go();
      await db.into(db.appSettingsTable).insert(
            AppSettingsTableCompanion.insert(
              darkMode: const Value(false),
              notificationsEnabled: const Value(false),
              hapticsEnabled: const Value(true),
              themeMode: Value(AppThemeMode.system.name),
            ),
          );
    });
    ReminderNotificationService.instance.configureGlobalEnabled(false);
  }
}
