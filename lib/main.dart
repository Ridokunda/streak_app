import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/database/drift_database.dart';
import 'features/streaks/data/repositories/streak_repository.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/notifications/data/services/reminder_notification_service.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance();
  await ReminderNotificationService.instance.initialize();
  final streakRepository = StreakRepository(db: await AppDatabase.instance());
  await streakRepository.refreshStreakCompletionFlags();
  await ReminderNotificationService.instance.clearAllStreakReminders();
  final streaks = await streakRepository.getAll();
  for (final streak in streaks) {
    await ReminderNotificationService.instance.syncStreakReminders(streak);
  }

  runApp(
    const ProviderScope(
      child: StreakApp(),
    ),
  );
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