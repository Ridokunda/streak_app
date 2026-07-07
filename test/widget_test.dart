import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_app/app/router/app_router.dart';
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
