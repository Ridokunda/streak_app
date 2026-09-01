import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_settings.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/data_management_service.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());
final dataManagementServiceProvider =
    Provider((ref) => DataManagementService());

final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

final hapticsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).asData?.value.hapticsEnabled ?? false;
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final settingsAsync = ref.watch(appSettingsProvider);
  return settingsAsync.when(
    data: (settings) => switch (settings.themeMode) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    },
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});
