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
}
