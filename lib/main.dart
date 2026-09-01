import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/database/drift_database.dart';
import 'features/streaks/data/repositories/streak_repository.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/settings/data/repositories/settings_repository.dart';
import 'features/notifications/data/services/reminder_notification_service.dart';
import 'features/todos/data/repositories/todo_repository.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: StreakApp(),
    ),
  );

  // Database maintenance and platform plugin calls must not delay the first
  // frame. If one of them fails, the app should remain usable and report the
  // failure instead of staying on the native launch screen.
  unawaited(_runStartupMaintenance());
}

Future<void> _runStartupMaintenance() async {
  try {
    final database = await AppDatabase.instance();
    final settingsRepository = SettingsRepository(db: database);
    var settings = await settingsRepository.getSettings();
    final streakRepository = StreakRepository(db: database);

    await streakRepository.refreshStreakCompletionFlags();

    final notificationService = ReminderNotificationService.instance;
    await notificationService.initialize();
    if (settings.notificationsEnabled &&
        !await notificationService.notificationsAllowed()) {
      await settingsRepository.updateNotifications(false);
      settings = settings.copyWith(notificationsEnabled: false);
    }
    notificationService.configureGlobalEnabled(settings.notificationsEnabled);
    await notificationService.clearAllStreakReminders();

    if (!settings.notificationsEnabled) {
      return;
    }

    final streaks = await streakRepository.getAll();
    final todos = await TodoRepository(db: database).getAll();
    for (final streak in streaks) {
      await notificationService.syncStreakReminders(streak);
    }
    for (final todo in todos) {
      if (todo.id != null) {
        await notificationService.syncTodoReminder(
          todoId: todo.id!,
          title: todo.title,
          reminderEnabled: todo.reminderEnabled,
          isCompleted: todo.isCompleted,
          reminderAt: todo.reminderAt,
        );
      }
    }
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'startup maintenance',
        context: ErrorDescription('while initializing background services'),
      ),
    );
  }
}

class StreakApp extends ConsumerWidget {
  const StreakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
