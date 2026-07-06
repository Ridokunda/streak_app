import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@Collection()
class AppSettings {
  /// Only one settings object should ever exist.
  Id id = 1;

  bool darkMode = true;

  bool notificationsEnabled = true;

  bool hapticsEnabled = true;

  AppSettings({
    this.darkMode = true,
    this.notificationsEnabled = true,
    this.hapticsEnabled = true,
  });
}