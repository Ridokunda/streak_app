import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/database/isar_database.dart';
import 'features/streaks/presentation/pages/home_page.dart';

import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarDatabase.instance();

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