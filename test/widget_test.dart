import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_app/app/router/app_router.dart';
import 'package:streak_app/features/achievements/domain/achievement_catalog.dart';
import 'package:streak_app/features/achievements/presentation/pages/achievements_page.dart';
import 'package:streak_app/features/achievements/presentation/providers/achievement_provider.dart';
import 'package:streak_app/core/enums/frequency.dart';
import 'package:streak_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:streak_app/features/streaks/data/models/streak.dart';
import 'package:streak_app/features/streaks/presentation/pages/create_streak_page.dart';
import 'package:streak_app/features/streaks/presentation/providers/streak_provider.dart';
import 'package:streak_app/main.dart';

void main() {
  setUp(() {
    appRouter.go('/');
  });

  testWidgets('shows create streak form from dashboard', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakListProvider.overrideWith((ref) => Stream<List<Streak>>.value(const [])),
        ],
        child: StreakApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);

    await tester.tap(find.text('Create Streak'));
    await tester.pumpAndSettle();

    expect(find.text('Create streak'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
  });

  testWidgets('shows dashboard streak overview', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakListProvider.overrideWith((ref) => Stream<List<Streak>>.value(const [])),
        ],
        child: StreakApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('dashboard summary cards fit without overflow', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakListProvider.overrideWith((ref) => Stream<List<Streak>>.value(const [])),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows weekday selection for custom frequency', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CreateStreakPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<Frequency>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custom').last);
    await tester.pumpAndSettle();

    expect(find.text('Select days of the week'), findsOneWidget);
    expect(find.text('Mon'), findsOneWidget);
  });

  testWidgets('shows validation errors for invalid streak title', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakListProvider.overrideWith((ref) => Stream<List<Streak>>.value(const [])),
        ],
        child: StreakApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Streak'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save streak'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
  });

  testWidgets('shows achievement progress from streak data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakListProvider.overrideWith(
            (ref) => Stream<List<Streak>>.value([
              Streak(
                title: 'Read',
                frequency: Frequency.daily,
                createdAt: DateTime(2026, 1, 1),
                currentStreak: 7,
                longestStreak: 7,
                freezeCount: 2,
              ),
              Streak(
                title: 'Exercise',
                frequency: Frequency.daily,
                createdAt: DateTime(2026, 1, 2),
                currentStreak: 3,
                longestStreak: 10,
                freezeCount: 1,
                lastFreezeUsed: DateTime(2026, 1, 8),
              ),
            ]),
          ),
          achievementTimelineProvider.overrideWith(
            (ref) => Stream<Map<String, DateTime>>.value({
              AchievementKeys.firstFlame: DateTime(2026, 1, 1),
              AchievementKeys.sevenDaySprint: DateTime(2026, 1, 7),
              AchievementKeys.closeCall: DateTime(2026, 1, 8),
            }),
          ),
        ],
        child: const MaterialApp(home: AchievementsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Unlocked achievements'), findsOneWidget);
    expect(find.text('First Flame'), findsOneWidget);
    expect(find.text('Seven Day Sprint'), findsOneWidget);
    expect(find.text('Earned 01 Jan 2026'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Monthly Legend'), 300);
    expect(find.text('Monthly Legend'), findsOneWidget);
    expect(find.text('10/30'), findsOneWidget);
  });

  testWidgets('shows unlocked badge chips on dashboard streak tile', (tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakListProvider.overrideWith(
            (ref) => Stream<List<Streak>>.value([
              Streak(
                title: 'Meditate',
                frequency: Frequency.daily,
                createdAt: DateTime(2026, 1, 1),
                currentStreak: 12,
                longestStreak: 12,
                freezeCount: 3,
                lastFreezeUsed: DateTime(2026, 1, 9),
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('7d'), findsOneWidget);
    expect(find.text('3F'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
