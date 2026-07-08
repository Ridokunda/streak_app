import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_app/app/router/app_router.dart';
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
      const ProviderScope(
        child: StreakApp(),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);

    await tester.tap(find.text('Create Streak'));
    await tester.pumpAndSettle();

    expect(find.text('Create streak'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
  });

  testWidgets('shows dashboard streak overview', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StreakApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Your streaks'), findsOneWidget);
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
      const ProviderScope(
        child: StreakApp(),
      ),
    );

    await tester.tap(find.text('Create Streak'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save streak'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
  });
}
