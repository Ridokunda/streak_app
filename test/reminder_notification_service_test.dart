import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_app/app/database/drift_database.dart';
import 'package:streak_app/core/enums/frequency.dart';
import 'package:streak_app/features/achievements/data/repositories/achievement_repository.dart';
import 'package:streak_app/features/notifications/data/services/reminder_notification_service.dart';
import 'package:streak_app/features/settings/data/repositories/settings_repository.dart';
import 'package:streak_app/features/streaks/data/models/streak.dart';
import 'package:streak_app/features/streaks/data/repositories/streak_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlatform.instance =
      AndroidFlutterLocalNotificationsPlugin();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final calls = <MethodCall>[];
  final service = ReminderNotificationService.instance;
  late AppDatabase db;
  late StreakRepository repository;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return call.method == 'initialize' ? true : null;
    });
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = StreakRepository(db: db, syncNotifications: false);
    await SettingsRepository(db: db).updateNotifications(true);
  });

  tearDown(() async {
    await db.close();
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<int> createStreak({bool archived = false}) => repository.add(Streak(
        title: 'Read',
        frequency: Frequency.daily,
        createdAt: DateTime.now(),
        remindersEnabled: true,
        reminderTimes: [9 * 60, 20 * 60],
        archived: archived,
      ));

  NotificationResponse response(
    String? payload, {
    String action = ReminderNotificationService.completeStreakAction,
    NotificationResponseType type =
        NotificationResponseType.selectedNotificationAction,
  }) =>
      NotificationResponse(
        notificationResponseType: type,
        actionId: action,
        payload: payload,
      );

  test('action completes once, updates achievements and keeps future reminders',
      () async {
    final id = await createStreak();
    // A fresh background engine starts with reminders disabled in memory.
    service.configureGlobalEnabled(false);
    await service.handleNotificationResponse(response('streak:$id'),
        database: db);
    await service.handleNotificationResponse(response('streak:$id'),
        database: db);

    final streak = (await repository.getById(id))!;
    expect(streak.completedToday, isTrue);
    expect(streak.currentStreak, 1);
    expect(streak.longestStreak, 1);
    expect(await repository.getCompletionsForStreak(id), hasLength(1));
    final stats = await AchievementRepository(db: db).getCompletionStats();
    expect(stats.totalCompletions, 1);

    final cancellations = calls.where((call) => call.method == 'cancel');
    expect(cancellations, hasLength(200));
    expect(cancellations.first.arguments['id'], id * 100);
    expect(cancellations.last.arguments['id'], id * 100 + 99);
    final scheduled = calls.where((call) => call.method == 'zonedSchedule');
    expect(scheduled, isNotEmpty);
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    for (final call in scheduled) {
      final arguments = call.arguments as Map;
      expect(arguments['payload'], 'streak:$id');
      expect(DateTime.parse(arguments['scheduledDateTime']).isBefore(tomorrow),
          isFalse);
      final actions = arguments['platformSpecifics']['actions'] as List;
      expect(actions.single['id'],
          ReminderNotificationService.completeStreakAction);
      expect(actions.single['title'], 'Mark completed');
      expect(actions.single['showsUserInterface'], isFalse);
      expect(actions.single['cancelNotification'], isTrue);
    }
  });

  test(
      'normal taps, other actions and invalid payloads never complete a streak',
      () async {
    final id = await createStreak();
    for (final event in [
      response('streak:$id',
          type: NotificationResponseType.selectedNotification),
      response('streak:$id', action: 'other'),
      response('todo:$id'),
      response(null),
      response('streak:invalid'),
      response('streak:-1'),
      response('streak:0'),
      response('streak:$id:extra'),
    ]) {
      await service.handleNotificationResponse(event, database: db);
    }
    expect(await repository.getCompletionsForStreak(id), isEmpty);
    expect(calls, isEmpty);
  });

  test('actions for deleted or archived streaks are ignored', () async {
    final deletedId = await createStreak();
    await repository.delete(deletedId);
    final archivedId = await createStreak(archived: true);
    for (final id in [deletedId, archivedId]) {
      await service.handleNotificationResponse(response('streak:$id'),
          database: db);
      expect(await repository.getCompletionsForStreak(id), isEmpty);
    }
    expect(calls, isEmpty);
  });

  test('completion respects persisted notification opt-out', () async {
    final id = await createStreak();
    await SettingsRepository(db: db).updateNotifications(false);
    service.configureGlobalEnabled(true);
    await service.handleNotificationResponse(response('streak:$id'),
        database: db);
    expect((await repository.getById(id))!.completedToday, isTrue);
    expect(calls.where((call) => call.method == 'cancel'), hasLength(100));
    expect(calls.where((call) => call.method == 'zonedSchedule'), isEmpty);
  });
}
