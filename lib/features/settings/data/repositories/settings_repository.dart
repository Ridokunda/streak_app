import 'package:drift/drift.dart';

import '../../../../app/database/drift_database.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  SettingsRepository({AppDatabase? db}) : _db = db;

  final AppDatabase? _db;

  Future<AppDatabase> get _dbInstance async =>
      _db ?? await AppDatabase.instance();

  Stream<AppSettings> watchSettings() async* {
    final db = await _dbInstance;

    yield* (db.select(db.appSettingsTable)..where((t) => t.id.equals(1)))
        .watch()
        .map((rows) {
      if (rows.isEmpty) {
        return AppSettings();
      }
      return _fromRow(rows.first);
    });
  }

  Future<AppSettings> getSettings() async {
    final db = await _dbInstance;
    final rows = await (db.select(db.appSettingsTable)
          ..where((t) => t.id.equals(1)))
        .get();

    if (rows.isNotEmpty) {
      return _fromRow(rows.first);
    }

    final defaults = AppSettingsTableCompanion.insert(
      darkMode: const Value(false),
      notificationsEnabled: const Value(false),
      hapticsEnabled: const Value(true),
      themeMode: Value(AppThemeMode.system.name),
    );
    await db.into(db.appSettingsTable).insertOnConflictUpdate(defaults);
    return AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    final db = await _dbInstance;
    final companion = AppSettingsTableCompanion(
      darkMode: Value(settings.themeMode == AppThemeMode.dark),
      notificationsEnabled: Value(settings.notificationsEnabled),
      hapticsEnabled: Value(settings.hapticsEnabled),
      themeMode: Value(settings.themeMode.name),
    );
    final updated = await (db.update(db.appSettingsTable)
          ..where((t) => t.id.equals(1)))
        .write(companion);
    if (updated == 0) {
      await db.into(db.appSettingsTable).insert(
            AppSettingsTableCompanion.insert(
              darkMode: companion.darkMode,
              notificationsEnabled: companion.notificationsEnabled,
              hapticsEnabled: companion.hapticsEnabled,
              themeMode: companion.themeMode,
            ),
          );
    }
  }

  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(themeMode: themeMode));
  }

  Future<void> updateNotifications(bool enabled) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(notificationsEnabled: enabled));
  }

  Future<void> updateHaptics(bool enabled) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(hapticsEnabled: enabled));
  }

  AppSettings _fromRow(AppSettingsTableData row) {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (value) => value.name == row.themeMode,
        orElse: () => row.darkMode ? AppThemeMode.dark : AppThemeMode.light,
      ),
      notificationsEnabled: row.notificationsEnabled,
      hapticsEnabled: row.hapticsEnabled,
    );
  }
}
