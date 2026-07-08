import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/database/drift_database.dart';
import 'features/notifications/data/services/reminder_notification_service.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance();
  await ReminderNotificationService.instance.initialize();

  runApp(
    const ProviderScope(
      child: StreakApp(),
    ),
  );
}

class StreakApp extends StatelessWidget {
  const StreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      routerConfig: appRouter,
    );
  }
}