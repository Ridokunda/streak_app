import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_app/main.dart';

void main() {
  testWidgets('shows create streak form from dashboard', (tester) async {
    await tester.pumpWidget(const StreakApp());

    expect(find.text('Dashboard'), findsOneWidget);

    await tester.tap(find.text('Create Streak'));
    await tester.pumpAndSettle();

    expect(find.text('Create streak'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
  });
}
