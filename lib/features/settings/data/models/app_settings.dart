enum AppThemeMode { system, light, dark }

class AppSettings {
  AppSettings({
    AppThemeMode? themeMode,
    bool? darkMode,
    this.notificationsEnabled = false,
    this.hapticsEnabled = true,
  }) : themeMode = themeMode ??
            (darkMode == null
                ? AppThemeMode.system
                : darkMode
                    ? AppThemeMode.dark
                    : AppThemeMode.light);

  final AppThemeMode themeMode;
  final bool notificationsEnabled;
  final bool hapticsEnabled;

  bool get darkMode => themeMode == AppThemeMode.dark;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? hapticsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
