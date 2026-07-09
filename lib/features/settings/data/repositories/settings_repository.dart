import 'package:drift/drift.dart';

import '../../../../app/database/drift_database.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  SettingsRepository({AppDatabase? db}) : _db = db;

  final AppDatabase? _db;

  Future<AppDatabase> get _dbInstance async => _db ?? await AppDatabase.instance();

  Stream<AppSettings> watchSettings() async* {
    final db = await _dbInstance;

    yield* (db.select(db.appSettingsTable)..where((t) => t.id.equals(1))).watch().map((rows) {
      if (rows.isEmpty) {
        return AppSettings();
      }
      return _fromRow(rows.first);
    });
  }

  Future<AppSettings> getSettings() async {
    final db = await _dbInstance;
    final row = await (db.select(db.appSettingsTable)..where((t) => t.id.equals(1))).getSingleOrNull();

    if (row != null) {
      return _fromRow(row);
    }

    final defaults = AppSettingsTableCompanion.insert();
    await db.into(db.appSettingsTable).insertOnConflictUpdate(defaults);
    return AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    final db = await _dbInstance;
    await db.into(db.appSettingsTable).insertOnConflictUpdate(
          AppSettingsTableCompanion.insert(
            darkMode: Value(settings.darkMode),
            notificationsEnabled: Value(settings.notificationsEnabled),
            hapticsEnabled: Value(settings.hapticsEnabled),
          ),
        );
  }

  Future<void> updateDarkMode(bool enabled) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(darkMode: enabled));
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
      darkMode: row.darkMode,
      notificationsEnabled: row.notificationsEnabled,
      hapticsEnabled: row.hapticsEnabled,
    );
  }
}
