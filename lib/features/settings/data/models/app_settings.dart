class AppSettings {
  int id = 1;

  bool darkMode = true;

  bool notificationsEnabled = true;

  bool hapticsEnabled = true;

  AppSettings({
    this.darkMode = true,
    this.notificationsEnabled = true,
    this.hapticsEnabled = true,
  });

  AppSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? hapticsEnabled,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
